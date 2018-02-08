# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils xdg-utils

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="https://audacious-media-player.org/"

if [[ ${PV} == *9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/audacious-media-player/audacious.git"
else
	SRC_URI="
		!gtk3? ( https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2 )
		gtk3? ( https://distfiles.audacious-media-player.org/${MY_P}-gtk3.tar.bz2 )"
	KEYWORDS="~amd64 ~x86"
fi

SRC_URI+=" mirror://gentoo/gentoo_ice-xmms-0.2.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
IUSE="gtk gtk3 nls qt5"
REQUIRED_USE="^^ ( gtk gtk3 qt5 )"

RDEPEND="
	>=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.28
	>=x11-libs/cairo-1.2.6
	>=x11-libs/pango-1.8.0
	virtual/freedesktop-icon-theme
	gtk? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool )"
PDEPEND="~media-plugins/audacious-plugins-${PV}"

src_unpack() {
	default
	if use gtk3; then
		mv "${MY_P}"{-gtk3,} || die
	fi
	[[ ${PV} == *9999 ]] && git-r3_src_unpack
}

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
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
		$(use_enable $(usex gtk gtk gtk3) gtk) \
		$(use_enable nls) \
		$(use_enable qt5 qt)
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
