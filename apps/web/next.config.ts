import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Next regenerates apps/web/AGENTS.md and CLAUDE.md on every dev start.
  // Buzzly keeps one agent contract at the repository root, so this stays off.
  agentRules: false,
};

export default nextConfig;
