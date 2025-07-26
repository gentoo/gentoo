# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

CRATES="
"

RUST_MIN_VER="1.77.2"
RUST_MULTILIB=1

inherit cargo gnome2 meson-multilib python-any-r1 rust-toolchain vala

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg https://gitlab.gnome.org/GNOME/librsvg"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-c-${PV}-crates.tar.xz"

LICENSE="LGPL-2.1+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT MPL-2.0
	Unicode-3.0
"

SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

IUSE="gtk-doc +introspection test +vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

RDEPEND="
	>=x11-libs/cairo-1.17.0[glib,svg(+),${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.9:2[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.20:2[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.50.0:2[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.0.0:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2=[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.50.0[${MULTILIB_USEDEP}]

	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/cargo-c
	x11-libs/gdk-pixbuf
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/docutils[${PYTHON_USEDEP}]')
	gtk-doc? ( dev-util/gi-docgen )
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

QA_FLAGS_IGNORED="
	usr/bin/rsvg-convert
	usr/lib.*/librsvg.*
	usr/lib.*/gdk-pixbuf*/*/loaders/*
"

pkg_setup() {
	rust_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	use vala && vala_setup
	gnome2_src_prepare
}

src_configure() {
	meson-multilib_src_configure
}

multilib_src_configure() {
	local emesonargs=(
		-Davif=disabled
		$(meson_native_use_feature introspection)
		-Dpixbuf=enabled
		-Dpixbuf-loader=enabled
		$(meson_native_use_feature gtk-doc docs)
		$(meson_native_use_feature vala)
		$(meson_use test tests)
	)

	if ! multilib_is_native_abi; then
		emesonargs+=(
			# Set the rust target, which can differ from CHOST
			-Dtriplet="$(rust_abi)"
		)
	fi

	cargo_env meson_src_configure
}

src_compile() {
	meson-multilib_src_compile
}

multilib_src_compile() {
	cargo_env meson_src_compile
}

multilib_src_test() {
	cargo_env meson_src_test
}

src_test() {
	meson-multilib_src_test
}

src_install() {
	meson-multilib_src_install
}

multilib_src_install() {
	cargo_env meson_src_install
}

multilib_src_install_all() {
	einstalldocs

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/Rsvg-2.0 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

pkg_postinst() {
	multilib_foreach_abi gnome2_pkg_postinst
}

pkg_postrm() {
	multilib_foreach_abi gnome2_pkg_postrm
}
