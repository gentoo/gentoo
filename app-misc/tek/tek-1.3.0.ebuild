# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit toolchain-funcs udev wxwidgets

DESCRIPTION="GUI tool for upgrading the firmware of a Truly Ergonomic Keyboard"
HOMEPAGE="https://trulyergonomic.com/ https://github.com/m-ou-se/tek"
SRC_URI="https://github.com/m-ou-se/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="all-rights-reserved GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}=[X]
	virtual/libusb:1
	virtual/udev"
DEPEND="${RDEPEND}"
BDEPEND="app-editors/vim-core"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CXX
	setup-wxwidgets
}

src_install() {
	newbin tek.lin tek
	udev_newrules linux-udev-rules 40-tek.rules
	einstalldocs
}

pkg_postinst() {
	udev_reload
}
