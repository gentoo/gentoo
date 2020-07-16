# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2-utils xdg-utils

DESCRIPTION="Xine movie player"
HOMEPAGE="https://xine-project.org/home"
SRC_URI="mirror://sourceforge/xine/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"
IUSE="aalib curl debug libcaca lirc nls readline vdr X xinerama"

RDEPEND="
	|| ( app-arch/tar app-arch/libarchive )
	media-libs/libpng:0=
	>=media-libs/xine-lib-1.2:=[aalib?,libcaca?]
	virtual/jpeg:0
	aalib? ( media-libs/aalib:= )
	curl? ( >=net-misc/curl-7.10.2:= )
	libcaca? ( media-libs/libcaca:= )
	lirc? ( app-misc/lirc:= )
	nls? ( virtual/libintl )
	readline? ( >=sys-libs/readline-6.2:= )
	X? (
		x11-libs/libICE:=
		x11-libs/libSM:=
		x11-libs/libX11:=
		x11-libs/libXext:=
		x11-libs/libXft:=
		x11-libs/libXrender:=
		x11-libs/libXScrnSaver:=
		x11-libs/libXtst:=
		x11-libs/libXv:=
		x11-libs/libXxf86vm:=
		xinerama? ( x11-libs/libXinerama:= )
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.18.3 )
	X? (
		x11-base/xorg-proto
		x11-libs/libXt
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-desktop.patch
	"${FILESDIR}"/${P}-libcaca.patch
)

src_prepare() {
	default
	eautoreconf
	rm misc/xine-bugreport || die
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable xinerama) \
		$(use_enable lirc) \
		$(use_enable vdr vdr-keys) \
		--disable-nvtvsimple \
		$(use_enable debug) \
		$(use_with X x) \
		$(use_with readline) \
		$(use_with curl) \
		$(use_with aalib) \
		$(use_with libcaca caca) \
		--without-fb
}

src_install() {
	# xine-list apparently may cause sandbox violation, bug 654394
	addpredict /dev/dri

	emake \
		DESTDIR="${D}" \
		docdir="/usr/share/doc/${PF}" \
		docsdir="/usr/share/doc/${PF}" \
		install

	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
