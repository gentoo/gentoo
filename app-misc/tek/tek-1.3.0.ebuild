# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
WX_GTK_VER=3.0

inherit udev wxwidgets

DESCRIPTION="GUI tool for upgrading the firmware of a Truly Ergonomic Keyboard"
HOMEPAGE="http://trulyergonomic.com/ https://github.com/m-ou-se/tek"
SRC_URI="https://github.com/m-ou-se/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="all-rights-reserved GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="x11-libs/wxGTK:${WX_GTK_VER}=[X]
	virtual/udev"
DEPEND="${RDEPEND}
	app-editors/vim-core"

src_prepare() {
	default
	setup-wxwidgets
	sed -r \
		-e '/LIN_STRIP/d' \
		-e 's/LIN_CXX/CXX/g' \
		-e 's/CXX=/CXX\?=/' \
		-e 's/CXXFLAGS=(.*)/CXXFLAGS:=\1 $(CXXFLAGS)/' \
		-i "${S}"/Makefile || die
}

src_install() {
	newbin tek.lin tek
	udev_newrules linux-udev-rules 40-tek.rules
	einstalldocs
}

pkg_postinst() {
	udev_reload
}
