# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson vala xdg

DESCRIPTION="Twitter client"
HOMEPAGE="https://ibboard.co.uk/cawbird/ https://github.com/IBBoard/cawbird"
SRC_URI="https://github.com/IBBoard/cawbird/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${P}

LICENSE="CC-BY-3.0 GPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE="gstreamer spell"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/atk
	dev-libs/glib:2
	dev-libs/json-glib
	net-libs/liboauth
	net-libs/libsoup:2.4
	net-libs/rest:0.7
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/pango
	gstreamer? (
		media-plugins/gst-plugins-gtk
		media-plugins/gst-plugins-hls
		media-plugins/gst-plugins-meta[ffmpeg,http,X]
	)
	spell? ( app-text/gspell:=[vala] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	virtual/pkgconfig
"

src_prepare() {
	default

	# Remove tests that require the network.
	for test in avatardownload filters inlinemediadownloader \
							   texttransform tweetparsing; do
		sed -i "/${test}/d" tests/meson.build || die
	done

	vala_setup
}

src_configure() {
	local emesonargs=(
		# these keys are taken from the readme of cawbird
		-Dconsumer_key_base64='VmY5dG9yRFcyWk93MzJEZmhVdEk5Y3NMOA=='
		-Dconsumer_secret_base64='MThCRXIxbWRESDQ2Y0podzVtVU13SGUyVGlCRXhPb3BFRHhGYlB6ZkpybG5GdXZaSjI='
		-Dexamples=false
		$(meson_use spell spellcheck)
		$(meson_use gstreamer video)
		-Dx11=true
	)
	meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}
