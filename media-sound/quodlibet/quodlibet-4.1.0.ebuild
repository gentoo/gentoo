# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )
inherit distutils-r1 gnome2-utils xdg-utils

DESCRIPTION="audio library tagger, manager, and player for GTK+"
HOMEPAGE="http://quodlibet.readthedocs.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+dbus gstreamer +udev"

RDEPEND="dev-libs/keybinder:3[introspection]
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.32[${PYTHON_USEDEP}]
	net-libs/libsoup[introspection]
	x11-libs/gtk+[introspection]
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0
		media-plugins/gst-plugins-meta:1.0
		)
	!gstreamer? ( media-libs/xine-lib )
	dbus? (
		app-misc/media-player-info
		dev-python/dbus-python[${PYTHON_USEDEP}]
		)
	udev? ( virtual/udev )
	!media-plugins/quodlibet-plugins"
DEPEND="dev-util/intltool"

S="${WORKDIR}/${PN}-release-${PV}/${PN}"

src_prepare() {
	local qlconfig=${PN}/config.py

	if ! use gstreamer; then
		sed -i -e '/backend/s:gstbe:xinebe:' ${qlconfig} || die
	fi

	sed -i -e '/gst_pipeline/s:"":"alsasink":' ${qlconfig} || die

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	dodoc NEWS README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg-utils_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg-utils_desktop_database_update
	gnome2_icon_cache_update
}
