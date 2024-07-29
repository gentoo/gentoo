# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A New Arch Tester Toolkit -- open-source stable-bot replacement"
HOMEPAGE="
	https://github.com/projg2/nattka/
	https://pypi.org/project/nattka/
"
SRC_URI="
	https://github.com/projg2/nattka/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="depgraph-order"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-util/pkgcheck[${PYTHON_USEDEP}]
	dev-vcs/git
	sys-apps/pkgcore[${PYTHON_USEDEP}]
	depgraph-order? (
		dev-python/networkx[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	>=dev-python/flit-core-3.7.1[${PYTHON_USEDEP}]
	test? (
		dev-python/vcrpy[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx doc --no-autodoc
EPYTEST_XDIST=1
distutils_enable_tests pytest
