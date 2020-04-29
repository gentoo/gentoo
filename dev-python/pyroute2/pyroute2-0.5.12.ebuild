# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )
PYTHON_REQ_USE="sqlite"
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="A pure Python netlink and Linux network configuration library."
HOMEPAGE="https://github.com/svinota/pyroute2"
SRC_URI="https://github.com/svinota/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

BDEPEND="
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

RESTRICT="!test? ( test )"

# tests need root access
RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}/pyroute2-0.5.12-readme-filename.patch"
)

distutils_enable_tests nose
