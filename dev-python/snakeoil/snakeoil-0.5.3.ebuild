# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/snakeoil/snakeoil-0.5.3.ebuild,v 1.5 2015/02/19 18:39:07 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://code.google.com/p/snakeoil/"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	SRC_URI="http://snakeoil.googlecode.com/files/${P}.tar.bz2"
fi

DESCRIPTION="Miscellaneous python utility code"
HOMEPAGE="http://snakeoil.googlecode.com/"

LICENSE="BSD"
SLOT="0"

DEPEND="!<sys-apps/pkgcore-0.4.7.8"
RDEPEND=${DEPEND}

python_configure_all() {
	# disable snakeoil 2to3 caching
	unset PY2TO3_CACHEDIR
}

python_test() {
	esetup.py test
}
