# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	glycin@3.1.0
	glycin-common@1.0.4
	glycin-utils@4.1.0
"
# These should be in the gentoo crate dist
CRATES+="
	libglycin-gtk4-rebind@0.1.0
	libglycin-gtk4-rebind-sys@0.1.0
	libglycin-rebind@0.1.0
	libglycin-rebind-sys@0.1.0
"
RUST_MIN_VER="1.92"

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
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="doc gtk +introspection vala test"
REQUIRED_USE="
	doc? ( introspection )
	gtk? ( introspection )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

DEPEND="
	>=media-libs/lcms-2.12:2
	>=dev-libs/glib-2.60:2
	>=sys-libs/libseccomp-2.5.0
	>=media-libs/fontconfig-2.13.0:1.0
	media-libs/glycin-loaders:2
	introspection? ( dev-libs/gobject-introspection )
	gtk? ( >=gui-libs/gtk-4.16.0:4 )
"

RDEPEND="${DEPEND}
	sys-apps/bubblewrap
"

BDEPEND="
	doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="
	usr/bin/${PN}-thumbnailer
	usr/lib.*/libglycin-2.so.0
	usr/lib.*/libglycin-gtk4-2.so.0
"

PATCHES=(
	"${FILESDIR}/${P}-pkgconfig-thumbnailer.patch" #973052
)

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		-Dlibglycin=true
		$(meson_use vala vapi)
		-Dglycin-loaders=false
		$(meson_use introspection)
		-Dglycin-thumbnailer=true
		$(meson_use gtk libglycin-gtk4)
		$(meson_use doc capi_docs)
		-Dtests=$(usex test true false)
		# required if glycin-loaders is installed seperately
		-Dtest_skip_install=true
	)

	meson_src_configure
	ln -s "${CARGO_HOME}" "${BUILD_DIR}/cargo-home" || die
}

src_install() {
	meson_src_install
	if use doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/libglycin{-2,-gtk4-2} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
