# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit gnome.org meson python-r1 vala xdg

DESCRIPTION="Git library for GLib"
HOMEPAGE="https://wiki.gnome.org/Projects/Libgit2-glib"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"
IUSE="gtk-doc python +ssh +vala"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# see bug #927383 wrt libgit2 upper bound
RDEPEND="
	>=dev-libs/gobject-introspection-1.54:=
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/libgit2-0.26.0:0=[ssh?]
	<dev-libs/libgit2-1.8.0
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
"

src_prepare() {
	default

	sed -i -e '/meson_python_compile.py/d' meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtk_doc)
		-Dintrospection=true
		-Dpython=false # we install python scripts manually
		$(meson_use ssh)
		$(meson_use vala vapi)
	)

	use vala && vala_setup
	meson_src_configure
}

src_install() {
	meson_src_install

	if use python ; then
		python_moduleinto gi.overrides
		python_foreach_impl python_domodule libgit2-glib/Ggit.py
	fi
}
