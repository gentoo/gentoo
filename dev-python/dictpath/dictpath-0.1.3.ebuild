# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

# Upstream has renamed to pathable after v0.1.3
DESCRIPTION="Object-oriented dictionary paths"
HOMEPAGE="
	https://pypi.org/project/dictpath/
"
SRC_URI="
	https://github.com/p1c2u/pathable/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/pathable-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"

BDEPEND="test? (
	dev-python/mock[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/--cov/d' setup.cfg || die
	distutils-r1_src_prepare
}
