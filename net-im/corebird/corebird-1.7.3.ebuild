# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.34

inherit autotools gnome2 vala virtualx

DESCRIPTION="Native GTK+3 Twitter client"
HOMEPAGE="https://corebird.baedert.org/"
SRC_URI="https://github.com/baedert/corebird/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gstreamer spellcheck"

RDEPEND="dev-db/sqlite:3
	>=dev-libs/glib-2.44:2
	dev-libs/json-glib
	gstreamer? ( >=media-libs/gst-plugins-bad-1.6:1.0[X,gtk]
		media-libs/gst-plugins-base:1.0[X]
		media-libs/gst-plugins-good:1.0
		media-plugins/gst-plugins-hls:1.0
		media-plugins/gst-plugins-libav:1.0
		media-plugins/gst-plugins-meta:1.0[X]
		media-plugins/gst-plugins-soup:1.0 )
	spellcheck? ( >=app-text/gspell-1.0[vala] )
	>=net-libs/libsoup-2.42.3.1
	>=x11-libs/gtk+-3.20:3"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-util/intltool-0.40
	sys-apps/sed
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable gstreamer video)
		--disable-gst-check
		$(use_enable spellcheck)
	)
	gnome2_src_configure "${myeconfargs[@]}"
}

src_test() {
	virtx emake check
}
