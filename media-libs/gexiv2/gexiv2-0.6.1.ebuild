# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gexiv2/gexiv2-0.6.1.ebuild,v 1.11 2015/04/08 17:59:35 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils multilib python-r1 toolchain-funcs versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="GObject-based wrapper around the Exiv2 library"
HOMEPAGE="http://trac.yorba.org/wiki/gexiv2/"
SRC_URI="http://www.yorba.org/download/${PN}/${MY_PV}/lib${PN}_${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="introspection static-libs"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-libs/glib:2
	>=media-gfx/exiv2-0.21"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/lib${P}

src_prepare() {
	tc-export CXX
	sed -e 's:CFLAGS:CXXFLAGS:g' -i Makefile || die
}

src_configure() {
	./configure \
		--prefix=/usr \
		$(use_enable introspection) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" LIB="$(get_libdir)" install
	dodoc AUTHORS NEWS README THANKS

	python_moduleinto gi/overrides/
	python_foreach_impl python_domodule GExiv2.py

	use static-libs || find "${D}" \( -name '*.a' -or -name '*.la' \) -delete
}
