#!/usr/bin/env bash

set -euo pipefail

DC="${DC:-exec}"
APP_NAME="${APP_NAME:-website}"

# If we're running in CI we need to disable TTY allocation for docker-compose
# commands that enable it by default, such as exec and run.
TTY=""
if [[ ! -t 1 ]]; then
  TTY="-T"
fi

# -----------------------------------------------------------------------------
# Helper functions start with _ and aren't listed in this script's help menu.
# -----------------------------------------------------------------------------

function _dc {
  # Run docker-compose command
  docker-compose "${DC}" ${TTY} "${@}"
}

function _build_run_down {
  # Build the docker image, run the command and then shut down the container
  docker-compose build
  docker-compose run ${TTY} "${@}"
  docker-compose down
}

# -----------------------------------------------------------------------------

function cmd {
  # Run any command you want in the web container
  _dc web "${@}"
}

function flask {
  # Run any Flask commands
  cmd flask "${@}"
}

function flake8 {
  # Lint Python code with flake8
  cmd flake8 "${@}"
}

function pytest {
  # Run test suite with pytest
  cmd pytest test/ "${@}"
}

function pytest-cov {
  # Get test coverage with pytest-cov
  cmd pytest --cov test/ --cov-report term-missing "${@}"
}

function bash {
  # Start a Bash session in the web container
  cmd bash "${@}"
}

function postgre-cli {
  # Connect to postgres with postgre-cli
  _dc postgres postgre-cli "${@}"
}

function pip3:install {
  # Install pip3 dependencies and write lock file
  _build_run_down web bin/pip3-install
}

function pip3:outdated {
  # List any installed packages that are outdated
  cmd pip3 list --outdated
}

function yarn:install {
  # Install yarn dependencies and write lock file
  _build_run_down webpack yarn install
}

function yarn:outdated {
  # List any installed packages that are outdated
  _dc webpack yarn outdated
}

function clean {
  # Remove cache and other machine generates files
  rm -rf .pytest_cache/ .webpack_cache/ public/* .coverage celerybeat-schedule
  touch public/.keep
}

function help {
  printf "%s <task> [args]\n\nTasks:\n" "${0}"

  compgen -A function | grep -v "^_" | cat -n

  printf "\nExtended help:\n  Each task has comments for general usage\n"
}

# This idea is heavily inspired by: https://github.com/adriancooney/Taskfile
TIMEFORMAT=$'\nTask completed in %3lR'
time "${@:-help}"

# this bash script was inspired by Nick Janetakis