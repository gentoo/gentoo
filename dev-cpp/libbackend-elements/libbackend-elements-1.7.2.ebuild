# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs versionator

DESCRIPTION="A collection of elementary building blocks for implementing compiler backends in c++"
HOMEPAGE="http://kolpackov.net/projects/libbackend-elements/"
SRC_URI="ftp://kolpackov.net/pub/projects/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE=""

RDEPEND=">=dev-cpp/libcult-1.4.6-r1
	dev-libs/boost"
DEPEND="${RDEPEND}
	dev-util/build:0.3"

src_configure() {
	BOOST_PKG="$(best_version ">=dev-libs/boost-1.35.0-r5")"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	BOOST_VER="$(replace_all_version_separators _ "${BOOST_VER}")"
	BOOST_INC="/usr/include/boost-${BOOST_VER}"

	mkdir -p build/{ld,cxx/gnu,import/libboost,import/libcult}

	cat >> build/cxx/configuration-dynamic.make <<- EOF
cxx_id       := gnu
cxx_optimize := n
cxx_debug    := n
cxx_rpath    := n
cxx_pp_extra_options :=
cxx_extra_options    := ${CXXFLAGS} -I${BOOST_INC}
cxx_ld_extra_options := ${LDFLAGS}
cxx_extra_libs       :=
cxx_extra_lib_paths  :=
	EOF

	cat >> build/cxx/gnu/configuration-dynamic.make <<- EOF
cxx_gnu := $(tc-getCXX)
cxx_gnu_libraries :=
cxx_gnu_optimization_options :=
	EOF

	cat >> build/import/libboost/configuration-dynamic.make <<- EOF
libboost_installed := y
libboost_suffix := -mt-${BOOST_VER}
	EOF

	cat >> build/import/libcult/configuration-dynamic.make <<- EOF
libcult_installed := y
	EOF

	cat >> build/ld/configuration-lib-dynamic.make <<- EOF
ld_lib_type   := shared
	EOF

	MAKEOPTS+=" verbose=1"
}

src_install() {
	find backend-elements -iname "*.cxx" \
		-o -iname "makefile" \
		-o -iname "*.o" -o -iname "*.d" \
		-o -iname "*.m4" -o -iname "*.l" \
		-o -iname "*.cpp-options" -o -iname "*.so" | xargs rm -f
	rm -rf backend-elements/arch

	insinto /usr/include
	doins -r backend-elements

	dodoc NEWS README documentation/[[:upper:]]*
	dohtml -A xhtml -r documentation/*
}
