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
  version "1.17.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/OrekGames/track-cli/releases/download/v#{version}/track-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "d9789a1277e8513b8494a08867506501dfc42b37d5baf92604aa829b8abb15d7"
    end

    on_intel do
      url "https://github.com/OrekGames/track-cli/releases/download/v#{version}/track-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "488b9f5380db452ead613418fcca69ee8ff74ba9ccf835e31a4fdc5fda9342d3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/OrekGames/track-cli/releases/download/v#{version}/track-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "14160fbbf67e83e14f50191a4482e1a3cc382669fdf48107a5c4d0a74a651050"
    end

    on_intel do
      url "https://github.com/OrekGames/track-cli/releases/download/v#{version}/track-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e3c73e790a1dedd67a43bc784cedd09bde8469301e3ee7c8ea6b01731ab2b5c8"
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

    # Install agent skill file to share prefix (used by post_install)
    if File.exist?("agent-skills/SKILL.md")
      (share/"track").install "agent-skills/SKILL.md"
    end
  end

  def post_install
    skill_src = share/"track/SKILL.md"
    return unless skill_src.exist?

    # Install skill globally for all supported AI coding tools
    %w[.claude .copilot .cursor .gemini].each do |tool_dir|
      skill_dir = Pathname.new(Dir.home)/tool_dir/"skills"/"track"
      skill_dir.mkpath
      cp skill_src, skill_dir/"SKILL.md"
    end
  end

  def caveats
    <<~EOS
      To use track, configure your tracker credentials:

        track init --url https://your-instance.com --token YOUR_TOKEN

      Or set environment variables:
        export TRACKER_URL="https://your-tracker-instance.com"
        export TRACKER_TOKEN="your-api-token"

      AI coding tool skills installed for:
        Claude Code, Copilot, Cursor, and Gemini CLI
        (~/.claude/skills/track/, ~/.copilot/skills/track/,
         ~/.cursor/skills/track/, ~/.gemini/skills/track/)

      For more information, see:
        track --help
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/track --version")
  end
end
