# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[rust-faces]='https://github.com/blissd/fotema-rust-faces;d1d1787344e5ce4252feaac7a75d83546dad482e;fotema-rust-faces-%commit%'
)

RUST_MIN_VER="1.92.0"

inherit cargo gnome2-utils meson xdg-utils

CRATE_P=${P/-/-v}
DESCRIPTION="Photo gallery for Linux"
HOMEPAGE="https://github.com/blissd/fotema"
SRC_URI="
	https://github.com/blissd/fotema/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://github.com/gentoo-crate-dist/fotema/releases/download/v${PV}/${CRATE_P}-crates.tar.xz
	"
fi

# see LICENSES/
LICENSE="
	CC-BY-2.0 CC-BY-4.0 CC-BY-NC-SA-4.0 CC-BY-SA-4.0 CC0-1.0
	FDL-1.3+ GPL-3+ MIT
"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD CC0-1.0
	CDLA-Permissive-2.0 ISC MIT MPL-2.0 UoI-NCSA openssl Unicode-3.0
	WTFPL-2 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/glib-2.66:2
	>=gui-libs/gtk-4.16:4
"
# indirect deps via crates
DEPEND+="
	dev-libs/openssl:=
	gui-libs/libadwaita
	media-libs/fontconfig
	media-libs/graphene
	media-libs/lcms:2
	media-libs/libshumate:=
	media-libs/opencv:=[contribdnn,features2d]
	media-video/ffmpeg:=
	sys-libs/libseccomp
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
"
RDEPEND="
	${DEPEND}
	media-libs/glycin-loaders:2
"
BDEPEND="
	dev-libs/glib:2
"

QA_FLAGS_IGNORED="/usr/bin/fotema"

src_configure() {
	local emesonargs=(
		-Dprofile=$(usex debug development default)
	)

	meson_src_configure
	ln -s "${CARGO_HOME}" "${BUILD_DIR}/cargo-home" || die

	# block trying to download onnxruntime
	export CARGO_NET_OFFLINE=true
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update

	ewarn "Face detection feature requires onnxruntime that is not packaged"
	ewarn "in ::gentoo.  If you enable the feature without the library installed,"
	ewarn "Fotema will crash."
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
