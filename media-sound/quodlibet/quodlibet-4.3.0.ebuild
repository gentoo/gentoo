# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 python3_7 python3_8 )
inherit distutils-r1 xdg-utils

DESCRIPTION="audio library tagger, manager, and player for GTK+"
HOMEPAGE="https://quodlibet.readthedocs.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 ~x86"
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
	udev? ( virtual/udev )"
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

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
