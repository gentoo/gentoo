# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Offers FRITZ!Box related core functionality."
HOMEPAGE="https://gitlab.com/tabos/librm"

SRC_URI="https://gitlab.com/tabos/librm/-/archive/v${PV}/${PN}-v${PV}.tar.bz2 -> ${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	net-libs/libsoup:2.4
	media-libs/speex
	dev-libs/libxml2:2
	>=media-libs/tiff-4.1.0
	media-libs/spandsp
	dev-libs/json-glib
	media-libs/libsndfile
	net-libs/gssdp
	net-libs/gupnp
	x11-libs/gtk+:3
	net-libs/libcapi
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	mv ${PN}-v${PV} ${PN}-${PV}
}
