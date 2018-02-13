# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit autotools eutils multilib python-r1 toolchain-funcs versionator vala xdg-utils

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="GObject-based wrapper around the Exiv2 library"
HOMEPAGE="https://wiki.gnome.org/Projects/gexiv2"
SRC_URI="mirror://gnome/sources/${PN}/${MY_PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="introspection python static-libs test vala"

REQUIRED_USE="
	python? ( introspection ${PYTHON_REQUIRED_USE} )
	test? ( python introspection )
	vala? ( introspection )
"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.26.1:2
	>=media-gfx/exiv2-0.21:0=
	introspection? ( dev-libs/gobject-introspection:= )
	vala? ( $(vala_depend) )
"
DEPEND="${RDEPEND}
	test? (
		dev-python/pygobject
		media-gfx/exiv2[xmp]
	)
	dev-libs/gobject-introspection-common
	virtual/pkgconfig"

src_prepare() {
	xdg_environment_reset
	tc-export CXX
	use vala && vala_src_prepare
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable introspection) \
		$(use_enable static-libs static) \
		$(use_enable vala)
}

src_install() {
	emake DESTDIR="${D}" LIB="$(get_libdir)" install
	dodoc AUTHORS NEWS README THANKS

	if use python ; then
		python_moduleinto gi/overrides/
		python_foreach_impl python_domodule GExiv2.py
	fi

	use static-libs || prune_libtool_files --modules
}
