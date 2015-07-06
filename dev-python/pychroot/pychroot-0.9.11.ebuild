# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pychroot/pychroot-0.9.11.ebuild,v 1.1 2015/07/06 01:41:04 radhermit Exp $

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

DESCRIPTION="a python library that simplifies chroot handling"
HOMEPAGE="https://github.com/pkgcore/pychroot"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND=">=dev-python/snakeoil-0.6.2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_test() {
	esetup.py test
}
