# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/_/-}-gtk3"
inherit gnome2-utils xdg-utils

DESCRIPTION="Lightweight and versatile audio player"
HOMEPAGE="https://audacious-media-player.org/"
SRC_URI="https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2
	mirror://gentoo/gentoo_ice-xmms-0.2.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	>=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.28
	>=x11-libs/cairo-1.2.6
	>=x11-libs/pango-1.8.0
	virtual/freedesktop-icon-theme
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool )
"
PDEPEND="~media-plugins/audacious-plugins-${PV}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	if ! use nls; then
		sed -e "/SUBDIRS/s/ po//" -i Makefile || die # bug #512698
	fi
}

src_configure() {
	# D-Bus is a mandatory dependency, remote control,
	# session management and some plugins depend on this.
	# Building without D-Bus is *unsupported* and a USE-flag
	# will not be added due to the bug reports that will result.
	# Bugs #197894, #199069, #207330, #208606
	econf \
		--disable-valgrind \
		--enable-dbus \
		--enable-gtk \
		$(use_enable nls)
}

src_install() {
	default

	# Gentoo_ice skin installation; bug #109772
	insinto /usr/share/audacious/Skins/gentoo_ice
	doins -r "${WORKDIR}"/gentoo_ice/.
	docinto gentoo_ice
	dodoc "${WORKDIR}"/README
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
