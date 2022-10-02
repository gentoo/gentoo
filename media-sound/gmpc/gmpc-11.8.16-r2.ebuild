# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools vala xdg

DESCRIPTION="A GTK+2 client for the Music Player Daemon"
HOMEPAGE="http://gmpc.wikia.com/wiki/Gnome_Music_Player_Client"
SRC_URI="http://download.sarine.nl/Programs/gmpc/$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls +unique xspf"

RDEPEND="
	dev-db/sqlite:3=
	dev-libs/glib:2
	dev-libs/libxml2:2
	media-libs/libmpd:=
	net-libs/libsoup:2.4
	sys-libs/zlib
	x11-libs/gtk+:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-themes/hicolor-icon-theme
	unique? ( dev-libs/libunique:1 )
	xspf? ( media-libs/libxspf )"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	app-text/gnome-doc-utils
	dev-util/gob
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)"

PATCHES=(
	"${FILESDIR}"/${P}-underlinking.patch
	"${FILESDIR}"/${P}-icons.patch
	"${FILESDIR}"/${P}-AM_CONFIG_HEADER.patch
)

src_prepare() {
	xdg_src_prepare
	eautoreconf
	vala_src_prepare
}

src_configure() {
	econf \
		--disable-static \
		--disable-libspiff \
		--disable-appindicator \
		--enable-mmkeys \
		$(use_enable nls) \
		$(use_enable unique) \
		$(use_enable xspf libxspf)
}
