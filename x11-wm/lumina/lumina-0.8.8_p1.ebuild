# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils vcs-snapshot

COMMIT_ID="248abdd"
DESCRIPTION="Lumina desktop environment"
HOMEPAGE="http://lumina-desktop.org/"
SRC_URI="https://github.com/pcbsd/lumina/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libxcb:0
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-wm"

RDEPEND="${DEPEND}
	kde-frameworks/oxygen-icons
	x11-misc/numlockx
	x11-wm/fluxbox
	x11-apps/xbacklight
	media-sound/alsa-utils
	sys-power/acpi
	app-admin/sysstat"

src_configure(){
	eqmake5 PREFIX="${ROOT}usr" L_ETCDIR="${ROOT}etc" LIBPREFIX="${ROOT}usr/$(get_libdir)" DESTDIR="${D}" CONFIG+="NO_I18N"
}

src_install(){
	default
	mv "${D}"/etc/luminaDesktop.conf.dist "${D}"/etc/luminaDesktop.conf || die
	mv "${D}"/?umina-* "${D}"/usr/bin || die
}
