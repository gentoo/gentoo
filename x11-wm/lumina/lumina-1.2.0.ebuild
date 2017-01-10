# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils
DESCRIPTION="Lumina desktop environment"
HOMEPAGE="http://lumina-desktop.org/"
I18N="161211"
SRC_URI="https://github.com/trueos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEPEND="dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtsvg:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	x11-libs/libxcb:0
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-wm"

DEPEND="$COMMON_DEPEND
	dev-qt/linguist-tools:5"

RDEPEND="$COMMON_DEPEND
	|| ( virtual/freedesktop-icon-theme
	x11-themes/hicolor-icon-theme )
	sys-fs/inotify-tools
	x11-misc/numlockx
	x11-wm/fluxbox
	x11-apps/xbacklight
	media-sound/alsa-utils
	sys-power/acpi
	app-admin/sysstat"

src_prepare(){
	default

	rm -rf src-qt5/desktop-utils || die

	sed -e "/desktop-utils/d" -i src-qt5/src-qt5.pro || die
}

src_configure(){
	eqmake5 PREFIX="${EPREFIX}/usr" L_BINDIR="${EPREFIX}/usr/bin" \
		L_ETCDIR="${EPREFIX}/etc" L_LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		LIBPREFIX="${EPREFIX}/usr/$(get_libdir)" DESTDIR="${D}" CONFIG+=WITH_I18N
}

src_install(){
	default
	mv "${ED%/}"/etc/luminaDesktop.conf{.dist,} || die
	rm "${ED%/}"/${PN}-* "${ED%/}"/start-${PN}-desktop || die
}
