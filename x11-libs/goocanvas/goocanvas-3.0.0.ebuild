# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Canvas widget for GTK+ using the cairo 2D library for drawing"
HOMEPAGE="https://wiki.gnome.org/GooCanvas"

LICENSE="LGPL-2"
SLOT="3.0"
KEYWORDS="~alpha amd64 ~arm64 ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="examples +introspection"

RDEPEND="
	>=x11-libs/cairo-1.10.0
	>=dev-libs/glib-2.28.0:2
	>=x11-libs/gtk+-3.0.0:3
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	>=dev-build/gtk-doc-am-1.16
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/goocanvas-3.0.0-fix-gcc14.patch
)

src_prepare() {
	# Do not build demos
	sed -e 's/^\(SUBDIRS =.*\)demo\(.*\)$/\1\2/' \
		-i Makefile.{am,in} || die "Failed to sed demo"

	# Python bindings are built/installed manually, but not at all anymore (py2).
	sed -e "/SUBDIRS = python/d" \
		-i bindings/Makefile.{am,in} || die "Failed to sed python subdirs"

	gnome2_src_prepare
}

src_configure() {
	PYTHON=true gnome2_src_configure \
		--disable-rebuilds \
		--disable-static \
		$(use_enable introspection) \
		--disable-python
}

src_install() {
	gnome2_src_install

	if use examples; then
		insinto "/usr/share/doc/${P}/examples/"
		doins demo/*.[ch] demo/*.png
	fi
}
