# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI="!gtk3? ( http://distfiles.audacious-media-player.org/${MY_P}.tar.bz2 )
	 gtk3? ( http://distfiles.audacious-media-player.org/${MY_P}-gtk3.tar.bz2 )
	 mirror://gentoo/gentoo_ice-xmms-0.2.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"

IUSE="+chardet nls gtk gtk3 qt5"
REQUIRED_USE="
	?? ( gtk gtk3 qt5 )
"
DOCS="AUTHORS"

RDEPEND=">=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.28
	>=x11-libs/cairo-1.2.6
	>=x11-libs/pango-1.8.0
	virtual/freedesktop-icon-theme
	chardet? ( >=app-i18n/libguess-1.2 )
	gtk?  ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	qt5? ( dev-qt/qtcore:5
	      dev-qt/qtgui:5
	      dev-qt/qtwidgets:5 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool )"

PDEPEND="~media-plugins/audacious-plugins-${PV}"

src_unpack() {
	default
	if use gtk3 ; then
		mv "${MY_P}-gtk3" "${MY_P}"
	fi
}

src_configure() {
	if use gtk ;then
		gtk="--enable-gtk"
	elif use gtk3 ;then
		gtk="--enable-gtk"
	else
		gtk="--disable-gtk"
	fi
	# D-Bus is a mandatory dependency, remote control,
	# session management and some plugins depend on this.
	# Building without D-Bus is *unsupported* and a USE-flag
	# will not be added due to the bug reports that will result.
	# Bugs #197894, #199069, #207330, #208606
	econf \
		--enable-dbus \
		${gtk} \
		$(use_enable chardet) \
		$(use_enable nls) \
		$(use_enable qt5 qt)
}

src_install() {
	default

	# Gentoo_ice skin installation; bug #109772
	insinto /usr/share/audacious/Skins/gentoo_ice
	doins "${WORKDIR}"/gentoo_ice/*
	docinto gentoo_ice
	dodoc "${WORKDIR}"/README
}
