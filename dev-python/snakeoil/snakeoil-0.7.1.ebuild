# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
PYTHON_REQ_USE="threads(+)"
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/snakeoil.git"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	SRC_URI="https://github.com/pkgcore/${PN}/releases/download/v${PV}/${P}.tar.gz"
fi

DESCRIPTION="misc common functionality and useful optimizations"
HOMEPAGE="https://github.com/pkgcore/snakeoil"

LICENSE="BSD"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_configure_all() {
	# disable snakeoil 2to3 caching
	unset PY2TO3_CACHEDIR
}

python_test() {
	esetup.py test
}
