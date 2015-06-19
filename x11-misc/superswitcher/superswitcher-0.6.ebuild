# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/superswitcher/superswitcher-0.6.ebuild,v 1.10 2015/01/24 19:18:35 jer Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="A more feature-full replacement of the Alt-Tab window switching behavior"
HOMEPAGE="http://code.google.com/p/superswitcher/"
SRC_URI="http://superswitcher.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/dbus-glib
	dev-libs/glib:2
	>=gnome-base/gconf-2:2
	x11-libs/gtk+:2
	>=x11-libs/libwnck-2.10:1
	x11-libs/libXcomposite
	x11-libs/libXinerama
	x11-libs/libXrender"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	gnome-base/gnome-common"

src_prepare() {
	sed -i \
		-e '/-DG.*_DISABLE_DEPRECATED/d' \
		src/Makefile.am || die #338906

	epatch "${FILESDIR}"/${P}-wnck-workspace.patch
	epatch "${FILESDIR}"/${PN}-0.6-glib-single-include.patch
	eautoreconf
}

src_install() {
	MAKEOPTS=-j1 default
}
