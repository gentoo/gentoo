# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
PYTHON_DEPEND="2"

inherit python

DESCRIPTION="command line selection of your X desktop environment"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="x11-apps/xinit"
DEPEND=""

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	cp "${FILESDIR}"/${P} "${T}"
	python_convert_shebangs -r 2 "${T}"
}

src_install() {
	newbin "${T}"/${P} dsx
}
