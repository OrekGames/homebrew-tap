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
  version "1.10.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/OrekGames/track-cli/releases/download/v#{version}/track-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "b7a039cc79b417b1ba3e2f69a7a5cd23e6b3641ac1c492b3d61fddd73d2650a1"
    end

    on_intel do
      url "https://github.com/OrekGames/track-cli/releases/download/v#{version}/track-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "d053262b3e2db01471322df4ef54a85e45a6ae9a9fc7f1e0df9086b45e372cc4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/OrekGames/track-cli/releases/download/v#{version}/track-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "afdd7e544f5854ee162a51b9b6663a9ded12f324b234b395343fbd1aa26f5828"
    end

    on_intel do
      url "https://github.com/OrekGames/track-cli/releases/download/v#{version}/track-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23fd0e22579cbf3aad8bfe5a7c54ed829f4e61275280d3d517af6bb95a701e91"
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
