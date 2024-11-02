# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Lightweight and versatile audio player"
HOMEPAGE="https://audacious-media-player.org/"
SRC_URI="
	https://distfiles.audacious-media-player.org/${P}.tar.bz2
	mirror://gentoo/gentoo_ice-xmms-0.2.tar.bz2
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="gtk qt6"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2
	virtual/freedesktop-icon-theme
	gtk? (
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		>=x11-libs/gtk+-3.18:3
		x11-libs/pango
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		dev-qt/qtsvg:6
	)
"
RDEPEND="${DEPEND}"
PDEPEND="~media-plugins/audacious-plugins-${PV}[gtk=,qt6=]"

src_configure() {
	# D-Bus is a mandatory dependency. Remote control,
	# session management and some plugins depend on this.
	# Building without D-Bus is *unsupported* and a USE-flag
	# will not be added due to the bug reports that will result.
	# Bugs #197894, #199069, #207330, #208606
	local emesonargs=(
		-Ddbus=true
		$(meson_use qt6 qt)
		-Dqt5=false
		$(meson_use gtk)
		-Dgtk2=false
		-Dlibarchive=false
		-Dbuildstamp="Gentoo ${P}"
		-Dvalgrind=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# Gentoo_ice skin installation; bug #109772
	insinto /usr/share/audacious/Skins/gentoo_ice
	doins -r "${WORKDIR}"/gentoo_ice/.
	docinto gentoo_ice
	dodoc "${WORKDIR}"/README
}
