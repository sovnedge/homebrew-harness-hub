# typed: strict
# frozen_string_literal: true

# Rendered by sovnedge/harness-hub's publish-harness-cli workflow from
# packaging/homebrew/harness.rb.tmpl for the harness-v0.1.2 tag. Do not edit
# by hand: the next release replaces this file.

require_relative "../lib/harness_hub_nexus_download_strategy"

# Installs the Harness Hub command line from the Service Operations Nexus.
class Harness < Formula
  desc "List, run and inspect Harness Hub harnesses"
  homepage "https://github.com/sovnedge/harness-hub"
  version "0.1.2"
  license :cannot_represent

  # The archives need a Nexus reader credential:
  # HOMEBREW_HARNESS_HUB_NEXUS_USERNAME and HOMEBREW_HARNESS_HUB_NEXUS_PASSWORD
  # (see lib/harness_hub_nexus_download_strategy.rb).
  on_macos do
    if Hardware::CPU.arm?
      url "https://artifacts.ops.sovn.net/repository/harness-hub/" \
          "cli/0.1.2/harness-0.1.2-darwin-arm64.tar.gz",
          using: HarnessHubNexusDownloadStrategy
      sha256 "4375e404b465ca5af1e5650df9638bc28d3a9b8e46218e2cdc767fd872dca7e6"
    else
      url "https://artifacts.ops.sovn.net/repository/harness-hub/" \
          "cli/0.1.2/harness-0.1.2-darwin-amd64.tar.gz",
          using: HarnessHubNexusDownloadStrategy
      sha256 "af41e6cc02e1e72b5cbb68706de1b90bfc0e3c57377fd259334aa00db93117a2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://artifacts.ops.sovn.net/repository/harness-hub/" \
          "cli/0.1.2/harness-0.1.2-linux-arm64.tar.gz",
          using: HarnessHubNexusDownloadStrategy
      sha256 "821e19a00cc689956ed2b60b3c7636fa673a6ac306f43042a0ce107fedbe341e"
    else
      url "https://artifacts.ops.sovn.net/repository/harness-hub/" \
          "cli/0.1.2/harness-0.1.2-linux-amd64.tar.gz",
          using: HarnessHubNexusDownloadStrategy
      sha256 "14f5de98faf3d312fe54550e3d081de5d2103dc9717493e6b5cd4c68993dfffa"
    end
  end

  def install
    bin.install "harness"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/harness version").strip
  end
end
