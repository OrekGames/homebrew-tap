# typed: false
# frozen_string_literal: true

# Homebrew formula for Track CLI
# A CLI for issue tracking systems (YouTrack, Jira, GitHub, GitLab)
#
# Installation:
#   brew tap OrekGames/tap
#   brew install track
#
# The version is read from the release URLs, so they carry it literally;
# scripts/update-homebrew-formula.sh rewrites the URLs and checksums.

class Track < Formula
  desc "CLI for issue tracking systems (YouTrack, Jira, GitHub, GitLab)"
  homepage "https://github.com/OrekGames/track-cli"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/OrekGames/track-cli/releases/download/v2.0.0/track-2.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "0fe3382276eaf54aaa732e9306ce9f0b75c5ff8626b2015eb51b59c5a56fba7b"
    end

    on_intel do
      url "https://github.com/OrekGames/track-cli/releases/download/v2.0.0/track-2.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "88617f60e041197411aeb9b1e502b34fc9f670b4c63af03868999dcac384b37d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/OrekGames/track-cli/releases/download/v2.0.0/track-2.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ff58a2bd9c28c024ad2cb9d3bf22f4a14eeaf09716c061443c5d3c86a861e4cf"
    end

    on_intel do
      url "https://github.com/OrekGames/track-cli/releases/download/v2.0.0/track-2.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cb17f0bfcf183fbfdb80d5a0e3aabbf724a826ec95d6d41a997f6249d511021d"
    end
  end

  def install
    bin.install "track"

    # Install shell completions if present in the archive
    bash_completion.install "track.bash" => "track" if File.exist?("track.bash")
    zsh_completion.install "_track" if File.exist?("_track")
    fish_completion.install "track.fish" if File.exist?("track.fish")

    # Install documentation
    doc.install "README.md" if File.exist?("README.md")
    doc.install "agent_guide.md" if File.exist?("agent_guide.md")

    # Keep a reference copy of the agent skill (SKILL.md and references/).
    # Homebrew runs post-install with an isolated HOME, so the skill and the
    # session hooks are installed per user by `track agent install` (see
    # caveats) rather than by the formula.
    pkgshare.install "agent-skills" if File.directory?("agent-skills")
  end

  def caveats
    <<~EOS
      To use track, configure your tracker credentials:

        track init --url https://your-instance.com --token YOUR_TOKEN

      Or set environment variables:
        export TRACKER_URL="https://your-tracker-instance.com"
        export TRACKER_TOKEN="your-api-token"

      To set up AI coding agents, run:

        track agent install

      It sets up Orek.ai, Claude Code, Codex, Cursor, Antigravity, Gemini CLI
      and Copilot: the track skill, and, where the tool supports one, a
      session-start hook that prints the project briefing (`track prime`).
      Run `track agent status` to see what went where, and add
      --scope project to set up one repository.

      For more information, see:
        track --help
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/track --version")
  end
end
