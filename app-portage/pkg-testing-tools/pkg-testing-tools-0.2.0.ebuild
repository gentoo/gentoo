# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Packages testing tools for Gentoo"
HOMEPAGE="https://github.com/APN-Pucky/pkg-testing-tools"
SRC_URI="https://github.com/APN-Pucky/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	sys-apps/portage[${PYTHON_USEDEP}]
"
