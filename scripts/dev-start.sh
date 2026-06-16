#!/usr/bin/env bash
#
# dev-start.sh — start the Quarkus development server for the ih-vdn module.
#
# Runs `./mvnw quarkus:dev`, which launches Quarkus in dev mode with live reload.
# If a settings.xml exists at the repository root, it is passed to Maven via -s.
# Any extra arguments are forwarded to Maven, e.g.:
#   ./scripts/dev-start.sh -Ddebug=5006
#
set -euo pipefail

# Resolve paths relative to this script so it works from anywhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_DIR="$REPO_ROOT/ih-vdn"
SETTINGS_FILE="$REPO_ROOT/settings.xml"

# Use the repo-root settings.xml if present; otherwise warn loudly and continue.
MVN_SETTINGS_ARGS=()
if [[ -f "$SETTINGS_FILE" ]]; then
    echo "Using Maven settings: $SETTINGS_FILE"
    MVN_SETTINGS_ARGS=(-s "$SETTINGS_FILE")
else
    cat >&2 <<'WARN'

################################################################################
#                                                                              #
#   ⚠️  WARNING: no settings.xml found at the repository root.                  #
#                                                                              #
#   Maven will run with its DEFAULT settings. If this project depends on a     #
#   private repository, mirror, or credentials defined in settings.xml, the    #
#   build will likely FAIL or pull the wrong artifacts.                        #
#                                                                              #
################################################################################

WARN
fi

cd "$PROJECT_DIR"

exec ./mvnw "${MVN_SETTINGS_ARGS[@]}" quarkus:dev "$@"
