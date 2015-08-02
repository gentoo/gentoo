# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pychroot/pychroot-9999.ebuild,v 1.6 2015/08/02 03:51:09 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pychroot.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="a python library and cli tool that simplify chroot handling"
HOMEPAGE="https://github.com/pkgcore/pychroot"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	=dev-python/snakeoil-9999[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
		dev-python/pytest[${PYTHON_USEDEP}]
	)"
[[ ${PV} == *9999 ]] && DEPEND+=" dev-python/sphinx[${PYTHON_USEDEP}]"

python_compile_all() {
	[[ ${PV} == *9999 ]] && emake -C doc man
}

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all
	emake -C doc PREFIX=/usr DESTDIR="${D}" install_man
}
