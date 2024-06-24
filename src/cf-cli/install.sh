#!/usr/bin/env bash
set -e

apt_get_update()
{
    echo "Running apt-get update..."
    apt-get update -y
}

apt_get_update

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            echo "Running apt-get update..."
            apt-get update -y
        fi
        apt-get -y install --no-install-recommends "$@"
    fi
}

export DEBIAN_FRONTEND=noninteractive

check_packages wget tee

install() {
    wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add - ; \
        echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
    apt-get -y install --no-install-recommends cf8-cli
}

echo "(*) Installing CloudFoundry CLI..."

install

echo "Done!"