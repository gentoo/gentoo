# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake vala xdg readme.gentoo-r1

DESCRIPTION="Modern Jabber/XMPP Client using GTK+/Vala"
HOMEPAGE="https://dino.im"

LICENSE="GPL-3"
SLOT="0"
IUSE="+gpg +http +omemo +notification-sound test"
RESTRICT="!test? ( test )"

MY_REPO_URI="https://github.com/dino/dino"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="${MY_REPO_URI}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="${MY_REPO_URI}/releases/download/v${PV}/${P}.tar.gz"
fi

RDEPEND="
	app-text/gspell[vala]
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/icu:=
	dev-libs/libgee:0.8=
	gui-libs/gtk:4
	>=gui-libs/libadwaita-1.2.0:1
	net-libs/glib-networking
	>=net-libs/libnice-0.1.15
	net-libs/libsignal-protocol-c
	net-libs/libsrtp:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	gpg? ( app-crypt/gpgme:= )
	http? ( net-libs/libsoup:2.4 )
	notification-sound? ( media-libs/libcanberra:0[sound] )
	omemo? (
		dev-libs/libgcrypt:=
		media-gfx/qrencode:=
	)
"
DEPEND="
	${RDEPEND}
	media-libs/gst-plugins-base
	media-libs/gstreamer
"
BDEPEND="
	sys-devel/gettext
	$(vala_depend)
"

src_configure() {
	vala_setup

	# TODO: Make videocalls (rtp) optional and not completely disable it
	local disabled_plugins=(
		$(usex gpg "" "openpgp")
		$(usex omemo "" "omemo")
		$(usex http  "" "http-files")
		"rtp"
	)
	local enabled_plugins=(
		$(usex notification-sound "notification-sound" "")
	)
	local mycmakeargs=(
		"-DENABLED_PLUGINS=$(local IFS=";"; echo "${enabled_plugins[*]}")"
		"-DDISABLED_PLUGINS=$(local IFS=";"; echo "${disabled_plugins[*]}")"
		"-DVALA_EXECUTABLE=${VALAC}"
		"-DBUILD_TESTS=$(usex test)"
	)

	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/xmpp-vala-test || die
}

src_install() {
	cmake_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	readme.gentoo_print_elog
}
