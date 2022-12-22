# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class RedesblockMop < Formula
  desc "BNB Cluster node"
  homepage ""
  version "0.9.1"
  depends_on :macos

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/redesblock/mop/releases/download/v0.9.1/mop-darwin-amd64.tar.gz"
      sha256 "a955a405f6d3e9f8c8ee951d51c8846855f0006b0d94f400f553f7cb025dd6b4"

      def install
        (etc/"mop").mkpath
        (var/"lib/mop").mkpath
        bin.install ["mop","mop-get-addr"]
        etc.install "mop.yaml" => "mop/mop.yaml" unless File.exists? etc/"mop/mop.yaml"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/redesblock/mop/releases/download/v0.9.1/mop-darwin-arm64.tar.gz"
      sha256 "3eb6a7e661ad6e0c4716e5e5e7d4082c560bc0c23637637d7f234edad07496fb"

      def install
        (etc/"mop").mkpath
        (var/"lib/mop").mkpath
        bin.install ["mop","mop-get-addr"]
        etc.install "mop.yaml" => "mop/mop.yaml" unless File.exists? etc/"mop/mop.yaml"
      end
    end
  end

  def post_install
    unless File.exists? "#{var}/lib/mop/password"
    system("openssl", "rand", "-out", var/"lib/mop/password", "-base64", "32")
    end
    system(bin/"mop", "init", "--config", etc/"mop/mop.yaml", ">/dev/null", "2>&1")
  end

  def caveats
    <<~EOS
      Logs:   #{var}/log/mop/mop.log
      Config: #{etc}/mop/mop.yaml

      MOP requires a BNB Smart Chain RPC endpoint to function. By default this is expected to be found at ws://localhost:8546.

      Please see https://redesblock.github.io/mop/#/installation/install for more details on how to configure your node.

      After you finish configuration run 'sudo mop-get-addr' and fund your node with BNB, and also MOP if so desired.
    EOS
  end

  plist_options startup: false

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>KeepAlive</key>
  <true/>
  <key>Label</key>
  <string>#{plist_name}</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{bin}/mop</string>
    <string>start</string>
    <string>--config</string>
    <string>#{etc}/mop/mop.yaml</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>#{var}/log/mop/mop.log</string>
  <key>StandardErrorPath</key>
  <string>#{var}/log/mop/mop.log</string>
</dict>
</plist>

    EOS
  end

  test do
    system "#{bin}/mop version"
  end
end
