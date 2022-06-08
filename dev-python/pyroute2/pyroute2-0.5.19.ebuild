# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8,9,10} pypy3 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="A pure Python netlink and Linux network configuration library"
HOMEPAGE="https://github.com/svinota/pyroute2"
SRC_URI="
	https://github.com/svinota/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 x86"

PATCHES=(
	"${FILESDIR}/${P}-exclude-tests.patch"
)

# tests need root access
RESTRICT="test"
