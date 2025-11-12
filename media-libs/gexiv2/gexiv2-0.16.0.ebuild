# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit gnome.org meson python-r1 vala

DESCRIPTION="GObject-based wrapper around the Exiv2 library"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gexiv2"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gexiv2.git"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="LGPL-2.1+ GPL-2+"
SLOT="0"
IUSE="gtk-doc +introspection python test +vala"
REQUIRED_USE="
	python? ( introspection ${PYTHON_REQUIRED_USE} )
	test? ( python introspection )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

RDEPEND="
	>=media-gfx/exiv2-0.26:=
	>=dev-libs/glib-2.46.0:2
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/meson-1.4
	dev-util/glib-utils
	gtk-doc? (
		dev-util/gtk-doc
		>=dev-util/gi-docgen-2021.1
		app-text/docbook-xml-dtd:4.3
	)
	test? ( >=media-gfx/exiv2-0.28[xmp] )
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use test tests)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
		$(meson_use vala vapi)
		-Dtools=false # requires vala, freshly promoted tool that some other distros don't ship yet either
		# Prevents installation of python modules (uses install_data from meson
		# which does not optimize the modules)
		-Dpython3=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html || die
		mv -v "${ED}"/usr/share/doc/gexiv2-0.16 "${ED}"/usr/share/gtk-doc/html/ || die
	fi

	if use python ; then
		python_moduleinto gi/overrides/
		python_foreach_impl python_domodule GExiv2.py
		python_foreach_impl python_optimize
	fi
}
