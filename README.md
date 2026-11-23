# sovnedge/homebrew-harness-hub

The Homebrew tap for `harness`, the Harness Hub command line: it lists, runs
and inspects harnesses through the Harness Hub runtime and checks a
repository's `.harness-hub/` declarations.

This repository is public, but only the formula is here. The source is
private (sovnedge/harness-hub), and the binaries are on the Service
Operations Nexus, `artifacts.ops.sovn.net`, in the raw repository
`harness-hub` under `cli/<version>/`.

**`artifacts.ops.sovn.net` is internal-only.** It is reachable only from the
internal network or over the VPN, and it allows no anonymous access. Off the
network, or without the reader credential below, `brew install` cannot
download anything.

## Credentials

Homebrew passes only `HOMEBREW_*` variables to a formula. Set the Nexus
reader credential in these two:

```sh
export HOMEBREW_HARNESS_HUB_NEXUS_USERNAME=service-operations-harness-hub-reader
export HOMEBREW_HARNESS_HUB_NEXUS_PASSWORD='<the reader password>'
```

The account `service-operations-harness-hub-reader` is read-only on the
`harness-hub` repository. Its password is in Vault at
`sovn/platform/service-operations/artifacts/nexus/harness-hub-reader`
(field `password`):

```sh
vault kv get -mount=sovn -field=password platform/service-operations/artifacts/nexus/harness-hub-reader
```

Ask a Service Operations operator for access if that is denied. Without the
variables, the download stops and names the one that is missing.

## Install

```sh
brew install sovnedge/harness-hub/harness
harness version
```

**Homebrew 7 needs the full name.** It refuses formulae from taps you have
not trusted. `brew install sovnedge/harness-hub/harness` taps this repository
and trusts the formula you named. To install or upgrade by the short name
`harness`, run `brew trust sovnedge/harness-hub` once first.

## Upgrade

```sh
brew update
brew upgrade sovnedge/harness-hub/harness
```

## How the formula is updated

Nobody edits `Formula/harness.rb` by hand. A `harness-v<semver>` tag on a
commit on sovnedge/harness-hub's `main` runs its
`.github/workflows/publish-harness-cli.yml`. That workflow builds the four
release archives (darwin/arm64, darwin/amd64, linux/amd64, linux/arm64)
reproducibly, publishes them and `checksums.txt` to
`https://artifacts.ops.sovn.net/repository/harness-hub/cli/<version>/`
(a published version is never replaced), renders the formula from
`packaging/homebrew/harness.rb.tmpl` with that version's sha256s, and commits
it here on `main` as the tap's publisher GitHub App. It never replaces a
published version's formula with different checksums, and never moves the
formula to an older version.

`Formula/` is empty until the first release.

## Why a download strategy

`lib/harness_hub_nexus_download_strategy.rb` downloads with HTTP Basic auth
built from the two variables at download time. A `headers:` option in the
formula cannot do this: while Homebrew evaluates a formula it replaces every
secret-looking `HOMEBREW_*` variable (such as one ending in `PASSWORD`) with a
placeholder, and only substitutes the real value where that placeholder
appears verbatim in a header or URL. Basic auth is base64 of
`user:password`, so a header built in the formula would encode the
placeholder. The strategy sends the header to curl on stdin (Homebrew keeps
`Authorization` headers off the command line) and follows no redirects.

## Checks

Pull requests and pushes to `main` run `brew style`, `brew readall` and
`brew audit --strict` on the tap (`.github/workflows/tests.yml`). They need no
Nexus credential: nothing is downloaded.
