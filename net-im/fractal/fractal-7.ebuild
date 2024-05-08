# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[mas-http]='https://github.com/matrix-org/matrix-authentication-service;099eabd1371d2840a2f025a6372d6428039eb511;matrix-authentication-service-%commit%/crates/http'
	[mas-iana]='https://github.com/matrix-org/matrix-authentication-service;099eabd1371d2840a2f025a6372d6428039eb511;matrix-authentication-service-%commit%/crates/iana'
	[mas-jose]='https://github.com/matrix-org/matrix-authentication-service;099eabd1371d2840a2f025a6372d6428039eb511;matrix-authentication-service-%commit%/crates/jose'
	[mas-oidc-client]='https://github.com/matrix-org/matrix-authentication-service;099eabd1371d2840a2f025a6372d6428039eb511;matrix-authentication-service-%commit%/crates/oidc-client'
	[matrix-sdk-base]='https://github.com/matrix-org/matrix-rust-sdk;88c4dec35f05ae295e0f2bf0362d6f5d72606d92;matrix-rust-sdk-%commit%/crates/matrix-sdk-base'
	[matrix-sdk-common]='https://github.com/matrix-org/matrix-rust-sdk;88c4dec35f05ae295e0f2bf0362d6f5d72606d92;matrix-rust-sdk-%commit%/crates/matrix-sdk-common'
	[matrix-sdk-crypto]='https://github.com/matrix-org/matrix-rust-sdk;88c4dec35f05ae295e0f2bf0362d6f5d72606d92;matrix-rust-sdk-%commit%/crates/matrix-sdk-crypto'
	[matrix-sdk-indexeddb]='https://github.com/matrix-org/matrix-rust-sdk;88c4dec35f05ae295e0f2bf0362d6f5d72606d92;matrix-rust-sdk-%commit%/crates/matrix-sdk-indexeddb'
	[matrix-sdk-qrcode]='https://github.com/matrix-org/matrix-rust-sdk;88c4dec35f05ae295e0f2bf0362d6f5d72606d92;matrix-rust-sdk-%commit%/crates/matrix-sdk-qrcode'
	[matrix-sdk-sqlite]='https://github.com/matrix-org/matrix-rust-sdk;88c4dec35f05ae295e0f2bf0362d6f5d72606d92;matrix-rust-sdk-%commit%/crates/matrix-sdk-sqlite'
	[matrix-sdk-store-encryption]='https://github.com/matrix-org/matrix-rust-sdk;88c4dec35f05ae295e0f2bf0362d6f5d72606d92;matrix-rust-sdk-%commit%/crates/matrix-sdk-store-encryption'
	[matrix-sdk-ui]='https://github.com/matrix-org/matrix-rust-sdk;88c4dec35f05ae295e0f2bf0362d6f5d72606d92;matrix-rust-sdk-%commit%/crates/matrix-sdk-ui'
	[matrix-sdk]='https://github.com/matrix-org/matrix-rust-sdk;88c4dec35f05ae295e0f2bf0362d6f5d72606d92;matrix-rust-sdk-%commit%/crates/matrix-sdk'
	[oauth2-types]='https://github.com/matrix-org/matrix-authentication-service;099eabd1371d2840a2f025a6372d6428039eb511;matrix-authentication-service-%commit%/crates/oauth2-types'
	[ruma-client-api]='https://github.com/ruma/ruma;4c00bd010dbdca6005bd599b52e90a0b7015d056;ruma-%commit%/crates/ruma-client-api'
	[ruma-common]='https://github.com/ruma/ruma;4c00bd010dbdca6005bd599b52e90a0b7015d056;ruma-%commit%/crates/ruma-common'
	[ruma-events]='https://github.com/ruma/ruma;4c00bd010dbdca6005bd599b52e90a0b7015d056;ruma-%commit%/crates/ruma-events'
	[ruma-federation-api]='https://github.com/ruma/ruma;4c00bd010dbdca6005bd599b52e90a0b7015d056;ruma-%commit%/crates/ruma-federation-api'
	[ruma-html]='https://github.com/ruma/ruma;4c00bd010dbdca6005bd599b52e90a0b7015d056;ruma-%commit%/crates/ruma-html'
	[ruma-identifiers-validation]='https://github.com/ruma/ruma;4c00bd010dbdca6005bd599b52e90a0b7015d056;ruma-%commit%/crates/ruma-identifiers-validation'
	[ruma-macros]='https://github.com/ruma/ruma;4c00bd010dbdca6005bd599b52e90a0b7015d056;ruma-%commit%/crates/ruma-macros'
	[ruma-push-gateway-api]='https://github.com/ruma/ruma;4c00bd010dbdca6005bd599b52e90a0b7015d056;ruma-%commit%/crates/ruma-push-gateway-api'
	[ruma]='https://github.com/ruma/ruma;4c00bd010dbdca6005bd599b52e90a0b7015d056;ruma-%commit%/crates/ruma'
	[vodozemac]='https://github.com/matrix-org/vodozemac;0c75746fc8a5eda4a0e490d345d1798b4c6cbd67;vodozemac-%commit%'
)

inherit cargo gnome2-utils meson

MY_P=${P/_/.}
CRATE_P=${P}_rc

DESCRIPTION="Matrix messaging app for GNOME written in Rust"
HOMEPAGE="
	https://wiki.gnome.org/Apps/Fractal
	https://gitlab.gnome.org/World/fractal/
"
SRC_URI="
	https://gitlab.gnome.org/World/fractal/-/archive/${PV/_/.}/${MY_P}.tar.bz2
	${CARGO_CRATE_URIS}
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://dev.gentoo.org/~mgorny/dist/${CRATE_P}-crates.tar.xz
	"
fi
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD GPL-3+ ISC MIT
	MPL-2.0 MPL-2.0 Unicode-DFS-2016 ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	>=dev-libs/glib-2.76
	>=gui-libs/gtk-4.12.0:4
	>=gui-libs/libadwaita-1.5.0:1

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
# clang needed by bindgen
BDEPEND="
	sys-devel/clang
	>=virtual/rust-1.75.0
"

# Rust
QA_FLAGS_IGNORED="usr/bin/fractal"

src_prepare() {
	default

	# upstream dev settings are insane
	sed -i -e 's:profile\.dev:ignored.insanity:' Cargo.toml || die
}

src_configure() {
	meson_src_configure
	ln -s "${CARGO_HOME}" "${BUILD_DIR}/cargo-home" || die
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}
