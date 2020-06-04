# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7,3_8} )
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson python-r1 vala xdg

DESCRIPTION="Git library for GLib"
HOMEPAGE="https://wiki.gnome.org/Projects/Libgit2-glib"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk-doc python +ssh +vala"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/gobject-introspection-1.54:=
	>=dev-libs/glib-2.44.0:2
	<dev-libs/libgit2-1.1:0=[ssh?]
	>=dev-libs/libgit2-0.26.0:0
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.1.2 )
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/libgit2-glib-0.99.0.1-vapilink.patch
)

src_prepare() {
	xdg_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtk_doc)
		-Dintrospection=true
		-Dpython=false # we install python scripts manually
		$(meson_use ssh)
		$(meson_use vala vapi)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	if use python ; then
		python_moduleinto gi.overrides
		python_foreach_impl python_domodule libgit2-glib/Ggit.py
	fi
}
