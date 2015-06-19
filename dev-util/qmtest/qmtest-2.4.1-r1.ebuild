# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/qmtest/qmtest-2.4.1-r1.ebuild,v 1.1 2015/02/22 01:51:09 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="CodeSourcery's test harness system"
HOMEPAGE="http://www.codesourcery.com/qmtest/"
SRC_URI="http://www.codesourcery.com/public/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install() {
	distutils-r1_src_install
	find "${D}" -name config.py -print0 | xargs -0 sed -i "s:${D}:/usr:"
	rm -r "${D}"usr/share/doc/${PN}/{COPYING,LICENSE.OPL} || die
	mv "${D}"usr/share/doc/${PN}/* "${D}"usr/share/doc/${PF} || die
	rm -r "${D}"/usr/share/doc/${PN} || die
}
