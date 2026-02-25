# typed: false
# frozen_string_literal: true

# Homebrew formula for Track CLI
# A CLI for issue tracking systems (YouTrack, Jira, GitHub, GitLab)
#
# Installation:
#   brew tap OrekGames/tap
#   brew install track

class Track < Formula
  desc "CLI for issue tracking systems (YouTrack, Jira, GitHub, GitLab)"
  homepage "https://github.com/OrekGames/track-cli"
  version "0.0.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/OrekGames/track-cli/releases/download/v#{version}/track-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "e97a31ac43b99bfdcb81165dbfb5886355ad0639bc8eb0f051ae0137e7cb5d20"
    end

    on_intel do
      url "https://github.com/OrekGames/track-cli/releases/download/v#{version}/track-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "008b6cf4b380427296303b9f274140eba276602248aa9719639b4b9ff27d958f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/OrekGames/track-cli/releases/download/v#{version}/track-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b535410bbb9976eacd95345b798fe245388fa83e4ccd4a7451783444ca26a7cd"
    end

    on_intel do
      url "https://github.com/OrekGames/track-cli/releases/download/v#{version}/track-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "adc2846705df41d24c351224976b26ac34ac88456c0c8ea566d04c545aeb236a"
    end
  end

  def install
    bin.install "track"

    # Install shell completions if present in the archive
    bash_completion.install "track.bash" => "track" if File.exist?("track.bash")
    zsh_completion.install "_track" if File.exist?("_track")
    fish_completion.install "track.fish" if File.exist?("track.fish")
  end

  def caveats
    <<~EOS
      To use track, configure your tracker credentials.

      Set environment variables:
        export TRACKER_URL="https://your-tracker-instance.com"
        export TRACKER_TOKEN="your-api-token"

      Or create a config file:
        track init --url https://your-instance.com --token YOUR_TOKEN

      For more information, see:
        track --help
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/track --version")
  end
end
