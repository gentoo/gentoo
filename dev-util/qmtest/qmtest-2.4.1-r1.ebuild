# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="CodeSourcery's test harness system"
HOMEPAGE="http://www.codesourcery.com/qmtest/"
SRC_URI="http://www.codesourcery.com/public/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install() {
	distutils-r1_src_install
	find "${ED}" -name config.py -print0 | xargs -0 sed -i "s:${ED}:${EPREFIX}/usr:"
	rm -r "${ED}"usr/share/doc/${PN}/{COPYING,LICENSE.OPL} || die
	mv "${ED}"usr/share/doc/${PN}/* "${ED}"usr/share/doc/${PF} || die
	rm -r "${ED}"/usr/share/doc/${PN} || die
}
