# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson vala xdg readme.gentoo-r1

DESCRIPTION="Modern Jabber/XMPP Client using GTK+/Vala"
HOMEPAGE="https://dino.im"

MY_REPO_URI="https://github.com/dino/dino"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="${MY_REPO_URI}.git"
	inherit git-r3
else
	SRC_URI="${MY_REPO_URI}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+gpg +http +notification-sound +omemo +rtp test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/icu:=
	dev-libs/libgee:0.8=
	gui-libs/gtk:4
	>=gui-libs/libadwaita-1.2.0:1[vala]
	media-libs/graphene
	net-libs/glib-networking
	net-libs/gnutls:=
	>=net-libs/libnice-0.1.22-r1
	net-libs/libomemo-c
	net-libs/libsrtp:2=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	gpg? ( app-crypt/gpgme:= )
	http? ( net-libs/libsoup:3.0 )
	notification-sound? ( media-libs/libcanberra:0[sound(+)] )
	omemo? (
		dev-libs/libgcrypt:=
		media-gfx/qrencode:=
	)
	rtp? (
		media-libs/gst-plugins-base:1.0
		media-libs/gstreamer:1.0
		media-libs/webrtc-audio-processing:1
	)
"
DEPEND="${RDEPEND}
	media-libs/gst-plugins-base
	media-libs/gstreamer
"
BDEPEND="
	sys-devel/gettext
	$(vala_depend)
"

src_configure() {
	vala_setup
	local emesonargs=(
		$(meson_feature gpg plugin-openpgp)
		$(meson_feature http plugin-http-files)
		$(meson_feature notification-sound plugin-notification-sound)
		$(meson_feature omemo plugin-omemo)
		$(meson_feature rtp plugin-rtp)
	)
	meson_src_configure
}

src_test() {
	"${BUILD_DIR}"/xmpp-vala/xmpp-vala-test || die
	meson_src_test
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	readme.gentoo_print_elog
}
