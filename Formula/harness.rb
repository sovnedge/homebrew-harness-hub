# typed: strict
# frozen_string_literal: true

# Rendered by sovnedge/harness-hub's publish-harness-cli workflow from
# packaging/homebrew/harness.rb.tmpl for the harness-v0.1.3 tag. Do not edit
# by hand: the next release replaces this file.

# Installs the Harness Hub command line from the Service Operations Nexus.
class Harness < Formula
  desc "List, run and inspect Harness Hub harnesses"
  homepage "https://github.com/sovnedge/harness-hub"
  version "0.1.3"
  license :cannot_represent

  # artifacts.ops.sovn.net is internal-only (internal network or VPN) and
  # serves these archives without credentials.
  on_macos do
    if Hardware::CPU.arm?
      url "https://artifacts.ops.sovn.net/repository/harness-hub/" \
          "cli/0.1.3/harness-0.1.3-darwin-arm64.tar.gz"
      sha256 "a23ba6bdaca01a5ccfde6957aab8dab4ebe97e41888df424127fc08f472f15d7"
    else
      url "https://artifacts.ops.sovn.net/repository/harness-hub/" \
          "cli/0.1.3/harness-0.1.3-darwin-amd64.tar.gz"
      sha256 "7ae9245fd7f8fb7ccf792a250bad7beeab4ec63202188f61425e0f8a34faf4de"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://artifacts.ops.sovn.net/repository/harness-hub/" \
          "cli/0.1.3/harness-0.1.3-linux-arm64.tar.gz"
      sha256 "53a259476fed2c9b3031452bbb15883c0db02181a9f365eaa0ef477a4d921ad3"
    else
      url "https://artifacts.ops.sovn.net/repository/harness-hub/" \
          "cli/0.1.3/harness-0.1.3-linux-amd64.tar.gz"
      sha256 "fb3120361e4892ab89248e05861a8870bdb198aa5dde54b363568b95fefbca9d"
    end
  end

  def install
    bin.install "harness"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/harness version").strip
  end
end
