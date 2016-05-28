# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pychroot.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/pkgcore/${PN}/releases/download/v${PV}/${P}.tar.gz"
fi

DESCRIPTION="a python library and cli tool that simplify chroot handling"
HOMEPAGE="https://github.com/pkgcore/pychroot"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/snakeoil-0.7.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
		dev-python/pytest[${PYTHON_USEDEP}]
	)"
[[ ${PV} == *9999 ]] && DEPEND+=" dev-python/sphinx[${PYTHON_USEDEP}]"

python_compile_all() {
	esetup.py build_man
}

python_test() {
	esetup.py test
}

python_install_all() {
	local DOCS=( NEWS.rst README.rst )
	distutils-r1_python_install install_man
	distutils-r1_python_install_all
}
