# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION=0.34

inherit autotools gnome2 vala virtualx xdg-utils

DESCRIPTION="Native GTK+3 Twitter client"
HOMEPAGE="https://corebird.baedert.org/"
SRC_URI="https://github.com/baedert/corebird/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gstreamer spellcheck"

RDEPEND="dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/json-glib
	gstreamer? ( media-plugins/gst-plugins-gtk:1.0
		media-libs/gst-plugins-base:1.0[X]
		media-libs/gst-plugins-good:1.0
		media-plugins/gst-plugins-hls:1.0
		media-plugins/gst-plugins-libav:1.0
		media-plugins/gst-plugins-meta:1.0[X]
		media-plugins/gst-plugins-soup:1.0 )
	spellcheck? ( app-text/gspell:=[vala] )
	net-libs/libsoup
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/intltool
	sys-apps/sed
	virtual/pkgconfig"

src_prepare() {
	# Disable that specific test because it would perform a download
	sed -i -e "/inlinemediadownloader/d" tests/Makefile.am || die
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
	# Need to have $HOME/.config and friends for the tests to work
	xdg_environment_reset
	virtx emake check
}
