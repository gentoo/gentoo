# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson vala

DESCRIPTION="Crossplatform access to image scanners"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork/libinsane"
SRC_URI="https://gitlab.gnome.org/World/OpenPaperwork/libinsane/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gtk-doc test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/gobject-introspection-1.82.0-r2
	media-gfx/sane-backends"
DEPEND="${RDEPEND}
	doc? (
		app-text/doxygen
		dev-util/gtk-doc
	)
	test? (
		dev-util/cunit
		media-gfx/sane-backends[sane_backends_test]
	)"

BDEPEND="dev-util/glib-utils
	virtual/pkgconfig
	$(vala_depend)"

PATCHES=( "${FILESDIR}"/${PN}-1.0.1-meson_options.patch
	)

src_prepare() {
	vala_setup
	default

	if ! use test; then
		sed -i "/^subdir('tests')/d" \
			subprojects/libinsane/meson.build || die
	fi
}

src_configure() {
	# Make meson think valgrind isn't found so tests run without it
	# https://bugs.gentoo.org/956347
	local native_file="${T}"/meson.${CHOST}.ini.local
	cat >> ${native_file} <<-EOF || die
[binaries]
valgrind='valgrind-falseified'
EOF

	local emesonargs=(
		$(meson_use doc doc)
		--native-file "${native_file}"
	)
	meson_src_configure
}
