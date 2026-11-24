# sovnedge/homebrew-harness-hub

The Homebrew tap for `harness`, the Harness Hub command line: it lists, runs
and inspects harnesses through the Harness Hub runtime and checks a
repository's `.harness-hub/` declarations.

This repository is public, but only the formula is here. The source is
private (sovnedge/harness-hub), and the binaries are on the Service
Operations Nexus, `artifacts.ops.sovn.net`, in the raw repository
`harness-hub` under `cli/<version>/`.

**`artifacts.ops.sovn.net` is internal-only.** It has no public DNS and is
reachable only from the internal network or over the VPN. There it serves the
archives without credentials, so off the network `brew install` cannot
download anything.

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

## Checks

Pull requests and pushes to `main` run `brew style`, `brew readall` and
`brew audit --strict` on the tap (`.github/workflows/tests.yml`). They don't
download anything.
