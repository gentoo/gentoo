# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/quark/quark-3.21.ebuild,v 1.18 2012/05/31 16:06:31 hasufell Exp $

EAPI=4
GCONF_DEBUG=yes
inherit flag-o-matic gnome2

DESCRIPTION="Quark is the Anti-GUI Music Player with a cool Docklet!"
HOMEPAGE="http://hsgg.github.com/quark/"
SRC_URI="http://hsgg.github.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="media-libs/xine-lib
	x11-libs/gtk+:2
	>=gnome-base/gconf-2
	gnome-base/gnome-vfs"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS README"

src_prepare() {
	sed -i \
		-e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		strange-quark/Makefile.{am,in} quark/Makefile.{am,in} || die #387823
}

src_configure() {
	#367859
	append-libs X11
	gnome2_src_configure
}
