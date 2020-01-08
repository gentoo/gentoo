# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_SINGLE_IMPL=true

inherit distutils-r1

DESCRIPTION="A python wrapper for Gnuplot"
HOMEPAGE="http://gnuplot-py.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	sci-visualization/gnuplot"

DOCS=( ANNOUNCE.txt CREDITS.txt FAQ.txt NEWS.txt TODO.txt )

PATCHES=( "${FILESDIR}"/${PN}-1.7-mousesupport.patch )

python_install_all() {
	use doc && local HTML_DOCS=( doc/Gnuplot/. )
	distutils-r1_python_install_all
}
# testsuite does NOT run unattended, so left out here
