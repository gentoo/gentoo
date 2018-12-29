# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

MY_PV=$(ver_cut 1-2)
inherit autotools python-r1 toolchain-funcs vala xdg-utils

DESCRIPTION="GObject-based wrapper around the Exiv2 library"
HOMEPAGE="https://wiki.gnome.org/Projects/gexiv2"
SRC_URI="mirror://gnome/sources/${PN}/${MY_PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="introspection python static-libs test vala"

REQUIRED_USE="
	python? ( introspection ${PYTHON_REQUIRED_USE} )
	test? ( python introspection )
	vala? ( introspection )
"

RDEPEND="${PYTHON_DEPS}
	dev-libs/glib:2
	media-gfx/exiv2:=
	introspection? ( dev-libs/gobject-introspection:= )
	vala? ( $(vala_depend) )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/gobject-introspection-common
	virtual/pkgconfig
	test? (
		dev-python/pygobject
		media-gfx/exiv2[xmp]
	)
"

PATCHES=( "${FILESDIR}/${P}-exiv2-0.27.patch" )

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
	einstalldocs

	if use python ; then
		python_moduleinto gi/overrides/
		python_foreach_impl python_domodule GExiv2.py
	fi

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
