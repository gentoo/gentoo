# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

DESCRIPTION="Library for video acquisition using Genicam cameras"
HOMEPAGE="https://github.com/AravisProject/aravis"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AravisProject/${PN}"
else
	MY_P="${PN^^}_${PV//./_}"
	SRC_URI="https://github.com/AravisProject/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2+"
SLOT="0"
IUSE="gtk-doc fast-heartbeat gstreamer introspection packet-socket test usb viewer"
RESTRICT="!test? ( test )"

GST_DEPEND="
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3
	)
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="
	dev-libs/glib:2[gtk-doc?]
	dev-libs/libxml2:2
	sys-libs/zlib
	gstreamer? ( ${GST_DEPEND} )
	packet-socket? ( sys-process/audit )
	usb? ( virtual/libusb:1 )
	viewer? (
		${GST_DEPEND}
		x11-libs/gtk+:3
		x11-libs/libnotify
	)
"
RDEPEND="${DEPEND}"

if [[ ${PV} != 9999 ]]; then
	S="${WORKDIR}/${PN}-${MY_P}"
fi

src_configure() {
	local emesonargs=(
		$(meson_feature gtk-doc documentation)
		$(meson_use fast-heartbeat)
		$(meson_feature gstreamer gst-plugin)
		$(meson_feature introspection)
		$(meson_feature packet-socket)
		$(meson_use test tests)
		$(meson_feature usb)
		$(meson_feature viewer)
	)
	meson_src_configure
}
