# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/tiemu/tiemu-3.03.ebuild,v 1.9 2012/10/20 06:17:21 xarthisius Exp $

EAPI=4
inherit eutils

DESCRIPTION="Texas Instruments hand-helds emulator"
HOMEPAGE="http://lpg.ticalc.org/prj_tiemu/"
SRC_URI="http://repo.calcforge.org/debian/source/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="dbus nls sdl threads xinerama"

RDEPEND="sci-libs/libticables2
	sci-libs/libticalcs2
	sci-libs/libtifiles2
	sci-libs/libticonv
	gnome-base/libglade:2.0
	x11-libs/gtk+:2
	dbus? ( >=dev-libs/dbus-glib-0.60 )
	nls? ( virtual/libintl )
	sdl? ( media-libs/libsdl )
	xinerama? ( x11-libs/libXinerama )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	xinerama? ( x11-proto/xineramaproto )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-remove_depreciated_gtk_calls.patch \
		"${FILESDIR}"/${P}-r2820.patch

	# Don't use GTK_DISABLE_DEPRECATED flags
	sed 's:-DGTK_DISABLE_DEPRECATED::g' -i configure.ac configure || die
}

src_configure() {
	econf \
		--disable-rpath \
		--disable-debugger \
		--disable-gdb \
		$(use_enable nls) \
		$(use_enable sdl sound) \
		$(use_enable threads) \
		$(use_enable threads threading) \
		$(use_with dbus) \
		--without-kde \
		$(use_with xinerama)
}

src_install() {
	default
	rm -f "${ED}"usr/share/tiemu/{Manpage.txt,COPYING,RELEASE,AUTHORS,LICENSES}
	make_desktop_entry tiemu "TiEmu Calculator" \
		"${EPREFIX}"/usr/share/tiemu/pixmaps/icon.xpm
}
