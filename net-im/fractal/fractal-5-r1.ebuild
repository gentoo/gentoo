# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[mas-http]='https://github.com/matrix-org/matrix-authentication-service;357481b52e6dc092178a16b8a7d86df036aac608;matrix-authentication-service-%commit%/crates/http'
	[mas-iana]='https://github.com/matrix-org/matrix-authentication-service;357481b52e6dc092178a16b8a7d86df036aac608;matrix-authentication-service-%commit%/crates/iana'
	[mas-jose]='https://github.com/matrix-org/matrix-authentication-service;357481b52e6dc092178a16b8a7d86df036aac608;matrix-authentication-service-%commit%/crates/jose'
	[mas-keystore]='https://github.com/matrix-org/matrix-authentication-service;357481b52e6dc092178a16b8a7d86df036aac608;matrix-authentication-service-%commit%/crates/keystore'
	[mas-oidc-client]='https://github.com/matrix-org/matrix-authentication-service;357481b52e6dc092178a16b8a7d86df036aac608;matrix-authentication-service-%commit%/crates/oidc-client'
	[mas-tower]='https://github.com/matrix-org/matrix-authentication-service;357481b52e6dc092178a16b8a7d86df036aac608;matrix-authentication-service-%commit%/crates/tower'
	[matrix-sdk-base]='https://github.com/matrix-org/matrix-rust-sdk;8895ce40d13faa79012144c97044990284215758;matrix-rust-sdk-%commit%/crates/matrix-sdk-base'
	[matrix-sdk-common]='https://github.com/matrix-org/matrix-rust-sdk;8895ce40d13faa79012144c97044990284215758;matrix-rust-sdk-%commit%/crates/matrix-sdk-common'
	[matrix-sdk-crypto]='https://github.com/matrix-org/matrix-rust-sdk;8895ce40d13faa79012144c97044990284215758;matrix-rust-sdk-%commit%/crates/matrix-sdk-crypto'
	[matrix-sdk-indexeddb]='https://github.com/matrix-org/matrix-rust-sdk;8895ce40d13faa79012144c97044990284215758;matrix-rust-sdk-%commit%/crates/matrix-sdk-indexeddb'
	[matrix-sdk-qrcode]='https://github.com/matrix-org/matrix-rust-sdk;8895ce40d13faa79012144c97044990284215758;matrix-rust-sdk-%commit%/crates/matrix-sdk-qrcode'
	[matrix-sdk-sqlite]='https://github.com/matrix-org/matrix-rust-sdk;8895ce40d13faa79012144c97044990284215758;matrix-rust-sdk-%commit%/crates/matrix-sdk-sqlite'
	[matrix-sdk-store-encryption]='https://github.com/matrix-org/matrix-rust-sdk;8895ce40d13faa79012144c97044990284215758;matrix-rust-sdk-%commit%/crates/matrix-sdk-store-encryption'
	[matrix-sdk-ui]='https://github.com/matrix-org/matrix-rust-sdk;8895ce40d13faa79012144c97044990284215758;matrix-rust-sdk-%commit%/crates/matrix-sdk-ui'
	[matrix-sdk]='https://github.com/matrix-org/matrix-rust-sdk;8895ce40d13faa79012144c97044990284215758;matrix-rust-sdk-%commit%/crates/matrix-sdk'
	[oauth2-types]='https://github.com/matrix-org/matrix-authentication-service;357481b52e6dc092178a16b8a7d86df036aac608;matrix-authentication-service-%commit%/crates/oauth2-types'
)

inherit cargo gnome2-utils meson

DESCRIPTION="Matrix messaging app for GNOME written in Rust"
HOMEPAGE="
	https://wiki.gnome.org/Apps/Fractal
	https://gitlab.gnome.org/GNOME/fractal/
"
SRC_URI="
	https://gitlab.gnome.org/GNOME/fractal/-/archive/${PV}/${P}.tar.bz2
	https://dev.gentoo.org/~mgorny/dist/${P}-crates.tar.xz
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD GPL-3+ ISC MIT
	MPL-2.0 MPL-2.0 Unicode-DFS-2016 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/glib-2.72
	>=gui-libs/gtk-4.10.0:4
	>=gui-libs/libadwaita-1.4.0:1

	>=media-libs/gstreamer-1.20:1.0
	>=media-libs/gst-plugins-bad-1.20:1.0
	>=media-libs/gst-plugins-base-1.20:1.0

	>=gui-libs/gtksourceview-5.0.0:5
	>=media-video/pipewire-0.3.0:=[gstreamer]
	>=dev-libs/openssl-1.0.1:=
	>=media-libs/libshumate-1.0.0:1.0
	>=dev-db/sqlite-3.24.0:3
	>=sys-apps/xdg-desktop-portal-1.14.1
"
RDEPEND="
	${DEPEND}
	virtual/secret-service
"

# Rust
QA_FLAGS_IGNORED="usr/bin/fractal"

PATCHES=(
	# https://gitlab.gnome.org/GNOME/fractal/-/merge_requests/1462
	"${FILESDIR}/${P}-secret-service.patch"
)

src_configure() {
	meson_src_configure
	ln -s "${CARGO_HOME}" "${BUILD_DIR}/cargo-home" || die
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
