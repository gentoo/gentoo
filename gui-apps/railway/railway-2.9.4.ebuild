# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"
RUST_MIN_VER="1.85.0"

inherit cargo gnome2-utils meson xdg-utils

DESCRIPTION="Travel with all your train information in one place"
HOMEPAGE="
	https://mobile.schmidhuberj.de/railway/
	https://gitlab.com/schmiddi-on-mobile/railway/
"
SRC_URI="
	https://gitlab.com/schmiddi-on-mobile/railway/-/archive/${PV}/${P}.tar.bz2
	${CARGO_CRATE_URIS}
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://github.com/gentoo-crate-dist/railway/releases/download/${PV}/${P}-crates.tar.xz
	"
fi

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT Unicode-3.0
	|| ( AGPL-3+ EUPL-1.2 )
"
# ring
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/glib-2.66
	dev-libs/openssl:=
	>=gui-libs/gtk-4.14:4
	>=gui-libs/libadwaita-1.8
	media-libs/graphene
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-libs/glib
	dev-util/blueprint-compiler
	sys-devel/gettext
"

BUILD_DIR=${S}/build
ECARGO_HOME=${BUILD_DIR}/cargo-home

QA_PREBUILT=usr/bin/diebahn

src_prepare() {
	default

	sed -e "s:get_option('profile.*:$(usex debug false true):" \
		-i src/meson.build || die
}

src_install() {
	meson_src_install
	dosym diebahn /usr/bin/railway
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
