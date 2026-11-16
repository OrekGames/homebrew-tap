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
      url "https://github.com/OrekGames/track-cli/releases/download/v1.19.2/track-1.19.2-aarch64-apple-darwin.tar.gz"
      sha256 "37251c0ff037e349da20c290d9f2a616bdd0c3207435e563bb09e618f65354b5"
    end

    on_intel do
      url "https://github.com/OrekGames/track-cli/releases/download/v1.19.2/track-1.19.2-x86_64-apple-darwin.tar.gz"
      sha256 "e81a87a092983000f21aab2abcd4a81e6d53e096a2b9cc9591f6cbbc716ee611"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/OrekGames/track-cli/releases/download/v1.19.2/track-1.19.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0d4a2987cbad9e6b88b2ec9e652b63da5ca6e85a3e5429f715f1c957d771d3b0"
    end

    on_intel do
      url "https://github.com/OrekGames/track-cli/releases/download/v1.19.2/track-1.19.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7b3e0ad9d2cc19348c2d80ccb78e02e728dd565e6f953652f7d105c075e7cb59"
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

    # Keep a reference copy of the agent skill. Homebrew runs post-install
    # with an isolated HOME, so the skill is installed per user by
    # `track init --skills` (see caveats) rather than by the formula.
    pkgshare.install "agent-skills/SKILL.md" if File.exist?("agent-skills/SKILL.md")
  end

  def caveats
    <<~EOS
      To use track, configure your tracker credentials:

        track init --url https://your-instance.com --token YOUR_TOKEN

      Or set environment variables:
        export TRACKER_URL="https://your-tracker-instance.com"
        export TRACKER_TOKEN="your-api-token"

      To install the track skill for Claude Code, Copilot, Cursor, and Gemini CLI
      (~/.claude/skills/track/, ~/.copilot/skills/track/,
       ~/.cursor/skills/track/, ~/.gemini/skills/track/), run:

        track init --skills

      For more information, see:
        track --help
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/track --version")
  end
end
