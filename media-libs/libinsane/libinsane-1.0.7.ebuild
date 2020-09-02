# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson vala

DESCRIPTION="Crossplatform access to image scanners"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork/libinsane"
SRC_URI="https://gitlab.gnome.org/World/OpenPaperwork/libinsane/-/archive/${PV}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gtk-doc test"

RDEPEND="dev-libs/gobject-introspection
	media-gfx/sane-backends"
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		dev-util/gtk-doc
	)
	test? (
		dev-util/cunit
		dev-util/valgrind
	)"

BDEPEND="dev-util/glib-utils
	virtual/pkgconfig
	$(vala_depend)"

# Tests require an operational valgrind
# https://wiki.gentoo.org/wiki/Debugging
RESTRICT="test"

PATCHES=( "${FILESDIR}"/${PN}-1.0.1-meson_options.patch )

src_prepare() {
	vala_src_prepare
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use doc doc)
	)
	meson_src_configure
}
