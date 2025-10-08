# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	glycin@3.0.8
	glycin-common@1.0.3
	glycin-utils@4.0.4
"

RUST_MIN_VER="1.85.0"

inherit cargo gnome.org meson vala

DESCRIPTION="Sandboxed and extendable image loading library"
HOMEPAGE="https://gnome.pages.gitlab.gnome.org/glycin"
SRC_URI+=" https://github.com/gentoo-crate-dist/glycin/releases/download/${PV}/${P}-crates.tar.xz ${CARGO_CRATE_URIS}"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD GPL-3+ IJG ISC
	LGPL-3+ MIT Unicode-3.0
	|| ( LGPL-2.1+ MPL-2.0 )
"
SLOT="2"
KEYWORDS="~amd64"
IUSE="+introspection vala test"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.60:2
	>=media-libs/fontconfig-2.13.0:=
	media-libs/glycin-loaders:2
	>=media-libs/lcms-2.12:=
	sys-apps/bubblewrap
	>=sys-libs/libseccomp-2.5.0
"

DEPEND="${RDEPEND}"

BDEPEND="
	vala? ( $(vala_depend) )
	virtual/pkgconfig
"

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		-Dwerror=false
		-Dlibglycin=true
		$(meson_use vala vapi)
		-Dglycin-loaders=false
		$(meson_use introspection)
		-Dglycin-thumbnailer=false
		-Dtests=$(usex test true false)
	)

	meson_src_configure
	ln -s "${CARGO_HOME}" "${BUILD_DIR}/cargo-home" || die
}

src_compile() {
	cargo_src_compile
	meson_src_compile
}

src_install() {
	cargo_env meson_src_install
}
