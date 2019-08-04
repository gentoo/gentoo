# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV/_beta/-beta.}
MY_P=${PN}-${MY_PV}

PYTHON_COMPAT=( python3_{5,6} )
inherit distutils-r1

DESCRIPTION="A Bash beautifier for the masses."
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
HOMEPAGE="https://github.com/lovesegfault/beautysh"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="BSD"
IUSE="test"

BDEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
}

python_test() {
	nosetests -v || die "Tests fail with ${EPYTHON}"
}
