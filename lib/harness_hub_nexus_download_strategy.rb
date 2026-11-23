# typed: strict
# frozen_string_literal: true

require "download_strategy"

# Downloads from the Service Operations Nexus (artifacts.ops.sovn.net, raw
# repository harness-hub, cli/<version>/), which is internal-only (internal
# network or VPN) and allows no anonymous access, with HTTP Basic auth from the
# Nexus reader credential service-operations-harness-hub-reader in
# HOMEBREW_HARNESS_HUB_NEXUS_USERNAME and HOMEBREW_HARNESS_HUB_NEXUS_PASSWORD.
#
# A `headers:` URL option cannot carry this credential. Homebrew masks every
# HOMEBREW_* variable whose name looks secret (it contains "password", "token",
# "auth" or "key") with a placeholder while it evaluates a formula, and swaps
# the real value back in only where the placeholder appears verbatim in a
# header or URL. Basic auth is base64 of "user:password", so a header built in
# the formula would encode the placeholder, not the password. This strategy
# builds the header when it downloads, after Homebrew has restored the
# environment, and fails with what to set when the credential is missing.
class HarnessHubNexusDownloadStrategy < CurlDownloadStrategy
  USERNAME_VARIABLE = "HOMEBREW_HARNESS_HUB_NEXUS_USERNAME"
  PASSWORD_VARIABLE = "HOMEBREW_HARNESS_HUB_NEXUS_PASSWORD"

  sig { override.params(timeout: T.nilable(T.any(Float, Integer))).void }
  def fetch(timeout: nil)
    authorization
    super
  end

  # The Authorization header on every request (Homebrew hands Authorization
  # headers to curl on stdin, so the credential is never in a command line or
  # log), and no redirects: Nexus serves the archives directly, so a redirect
  # would only carry the credential somewhere else.
  sig { returns(T::Array[String]) }
  def _curl_args
    super + ["--max-redirs", "0", "--header", "Authorization: #{authorization}"]
  end

  private

  sig { returns(String) }
  def authorization
    username = ENV.fetch(USERNAME_VARIABLE, "")
    password = ENV.fetch(PASSWORD_VARIABLE, "")
    if username.empty? || password.empty?
      missing = [(USERNAME_VARIABLE if username.empty?), (PASSWORD_VARIABLE if password.empty?)].compact
      raise CurlDownloadStrategyError.new(url, <<~EOS)
        #{missing.join(" and ")} #{(missing.length == 1) ? "is" : "are"} not set.
        artifacts.ops.sovn.net requires a Nexus reader credential. Set both:
          export #{USERNAME_VARIABLE}=service-operations-harness-hub-reader
          export #{PASSWORD_VARIABLE}=<the reader password>
        The password is in Vault at
        sovn/platform/service-operations/artifacts/nexus/harness-hub-reader
        (field password). artifacts.ops.sovn.net is internal-only: connect to
        the VPN or the internal network first.
        See https://github.com/sovnedge/homebrew-harness-hub#credentials.
      EOS
    end
    "Basic #{["#{username}:#{password}"].pack("m0")}"
  end
end
