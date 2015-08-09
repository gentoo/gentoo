# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools eutils gnome2

DESCRIPTION="Tetrinet Clone for GNOME"
HOMEPAGE="http://gtetrinet.sourceforge.net/"
SRC_URI="${SRC_URI}
	mirror://gentoo/gtetrinet-gentoo-theme-0.1.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls ipv6"

RDEPEND="
	dev-libs/libxml2
	media-libs/libcanberra
	>=gnome-base/gconf-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-noesd.patch
	epatch "${FILESDIR}"/${P}-desktopfile.patch
	epatch "${FILESDIR}"/${P}-format-security.patch
	sed -i \
		-e "/^pkgdatadir =/s:=.*:= ${GAMES_DATADIR}/${PN}:" \
		src/Makefile.in themes/*/Makefile.in || die
	sed -i \
		-e '/^gamesdir/s:=.*:=@bindir@:' \
		src/Makefile.am || die

	rm -rf "${WORKDIR}"/gentoo/.xvpics || die # Remove cruft

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable ipv6)
}

src_install() {
	gnome2_src_install
	mv "${WORKDIR}"/gentoo "${ED}/usr/share/${PN}/themes/" || die
}
