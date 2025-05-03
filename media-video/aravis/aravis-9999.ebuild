# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Library for video acquisition using Genicam cameras"
HOMEPAGE="https://github.com/AravisProject/aravis"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AravisProject/${PN}"
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/AravisProject/${PN}/releases/download/$PV/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2+"
SLOT="0"
IUSE="doc fast-heartbeat gstreamer introspection packet-socket test usb viewer"
RESTRICT="!test? ( test )"

GST_DEPEND="
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3
	)
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="
	dev-libs/glib:2
	doc? (
		dev-libs/glib:2[gtk-doc(+),doc(+)]
	)
	dev-libs/libxml2:2=
	sys-libs/zlib
	gstreamer? ( ${GST_DEPEND} )
	packet-socket? ( sys-process/audit )
	usb? ( virtual/libusb:1 )
	viewer? (
		${GST_DEPEND}
		x11-libs/gtk+:3
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		$(meson_feature doc documentation)
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
