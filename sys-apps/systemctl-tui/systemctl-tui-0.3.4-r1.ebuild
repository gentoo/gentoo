# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
inherit cargo

DESCRIPTION="A simple TUI for interacting with systemd services and their logs"
HOMEPAGE="https://github.com/rgwood/systemctl-tui/"
SRC_URI="
	https://github.com/rgwood/systemctl-tui/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 Boost-1.0 MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="*"
