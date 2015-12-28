# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit flag-o-matic toolchain-funcs eutils multilib versionator

DESCRIPTION="a simple, small, C++ XML parser that can be easily integrating into other programs"
HOMEPAGE="http://www.grinninglizard.com/tinyxml/index.html"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV//./_}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ppc ~ppc64 sparc x86 ~x64-macos ~x86-macos"
IUSE="debug doc static-libs +stl"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}"

src_prepare() {
	local major_v=$(get_major_version)
	local minor_v=$(get_version_component_range 2-3)

	sed -e "s:@MAJOR_V@:$major_v:" \
	    -e "s:@MINOR_V@:$minor_v:" \
		"${FILESDIR}"/Makefile-3 > Makefile || die

	epatch "${FILESDIR}"/${PN}-2.6.1-entity.patch

	use debug && append-cppflags -DDEBUG
	use stl && epatch "${FILESDIR}"/${P}-defineSTL.patch

	if ! use static-libs; then
		sed -e "/^all:/s/\$(name).a //" -i Makefile || die
	fi

	tc-export AR CXX RANLIB

	[[ ${CHOST} == *-darwin* ]] && export LIBDIR="${EPREFIX}"/usr/$(get_libdir)
}

src_install() {
	dolib.so *$(get_libname)*

	insinto /usr/include
	doins *.h

	dodoc {changes,readme}.txt

	use doc && dohtml -r docs/*
}
