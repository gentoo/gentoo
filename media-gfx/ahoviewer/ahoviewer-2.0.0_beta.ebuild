# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

MY_PV="$(ver_rs 3 -)"

DESCRIPTION="A GTK image viewer, manga reader, and booru browser"
HOMEPAGE="https://github.com/ahodesuka/ahoviewer"
SRC_URI="https://github.com/ahodesuka/ahoviewer/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome-keyring gnutls +gstreamer plugins +rar +ssl +zip"

DEPEND="dev-cpp/glibmm:=
	dev-cpp/gtkmm:3.0=
	dev-libs/libconfig:=[cxx]
	dev-libs/libsigc++:2=
	dev-libs/libxml2:2=
	media-libs/libnsgif
	net-misc/curl
	x11-libs/gtk+:3
	gnome-keyring? ( app-crypt/libsecret )
	gstreamer? (
		media-libs/gst-plugins-bad:1.0
		media-libs/gstreamer:1.0
	)
	plugins? ( dev-libs/libpeas )
	rar? ( app-arch/unrar:= )
	ssl? (
		gnutls? (
			dev-libs/libgcrypt:=
			net-libs/gnutls:=
			net-misc/curl[curl_ssl_gnutls]
		)
		!gnutls? (
			dev-libs/openssl:=
			net-misc/curl[curl_ssl_openssl]
		)
	)
	zip? ( dev-libs/libzip )
"
RDEPEND="${DEPEND}
	gstreamer? (
		media-libs/gst-plugins-base:1.0[X]
		media-libs/gst-plugins-good:1.0
		|| (
			media-plugins/gst-plugins-vpx
			media-plugins/gst-plugins-libav
		)
	)"

# In future (-beta), pull https://github.com/ahodesuka/ahoviewer-plugins
# directly via SRC_URI="plugins? ( )", or add as a separate package. It
# depends on how the plugins are handled.
#PDEPEND="plugins? ( x11-misc/ahoviewer-plugins )"

S="${WORKDIR}/ahoviewer-${MY_PV}"

src_prepare() {
	default

	# Hopefully related to beta/git, incomplete release.
	cat <<- EOF > src/version.h || die
		#ifndef _VERSION_H_
		#define AHOVIEWER_VERSION "${MY_PV}"
		extern const char *const ahoviewer_version;
		#endif // _VERSION_H_
	EOF
}

src_configure() {
	local emesonargs=(
		$(meson_feature gnome-keyring libsecret)
		$(meson_feature gstreamer)
		$(meson_feature plugins libpeas)
		$(meson_feature rar libunrar)
		$(meson_feature zip libzip)
	)

	meson_src_configure
}
