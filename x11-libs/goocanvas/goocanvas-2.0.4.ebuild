# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-r1

DESCRIPTION="Canvas widget for GTK+ using the cairo 2D library for drawing"
HOMEPAGE="https://wiki.gnome.org/GooCanvas"

LICENSE="LGPL-2"
SLOT="2.0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="examples +introspection python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# python only enables python specific binding override
RDEPEND="
	>=x11-libs/gtk+-3.0.0:3
	>=dev-libs/glib-2.28.0:2
	>=x11-libs/cairo-1.10.0
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-2.90.4:3[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.16
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

src_prepare() {
	# Do not build demos
	sed -e 's/^\(SUBDIRS =.*\)demo\(.*\)$/\1\2/' \
		-i Makefile.am Makefile.in || die "sed failed"

	# Python bindings are built/installed manually.
	sed -e "/SUBDIRS = python/d" -i bindings/Makefile.am bindings/Makefile.in

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-rebuilds \
		--disable-static \
		$(use_enable introspection) \
		--disable-python
}

src_install() {
	gnome2_src_install

	if use python; then
		sub_install() {
			python_moduleinto $(python -c "import gi;print gi._overridesdir")
			python_domodule bindings/python/GooCanvas.py
		}
		python_foreach_impl sub_install
	fi

	if use examples; then
		insinto "/usr/share/doc/${P}/examples/"
		doins demo/*.[ch] demo/*.png
	fi
}
