# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libxsd-frontend/libxsd-frontend-1.18.0-r3.ebuild,v 1.4 2014/08/10 19:54:52 slyfox Exp $

EAPI="5"

inherit eutils toolchain-funcs versionator

DESCRIPTION="A compiler frontend for the W3C XML Schema definition language"
HOMEPAGE="http://www.codesynthesis.com/projects/libxsd-frontend/"
SRC_URI="http://www.codesynthesis.com/download/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"

RDEPEND=">=dev-libs/xerces-c-3
	>=dev-libs/boost-1.52.0-r1:=[threads]
	>=dev-cpp/libcult-1.4.6-r1
	>=dev-cpp/libfrontend-elements-1.1.4"
DEPEND="${RDEPEND}
	dev-util/build:0.3"

src_prepare() {
	epatch "${FILESDIR}/1.17.0-boost-filesystem-v2-deprecation.patch"
}

src_configure() {
	mkdir -p \
		build/{ld,cxx/gnu} \
		build/import/lib{boost,cult,frontend-elements,xerces-c}

	cat >> build/cxx/configuration-dynamic.make <<- EOF
cxx_id       := gnu
cxx_optimize := n
cxx_debug    := n
cxx_rpath    := n
cxx_pp_extra_options :=
cxx_extra_options    := ${CXXFLAGS}
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
libboost_system := y
	EOF
	cat >> build/import/libcult/configuration-dynamic.make <<- EOF
libcult_installed := y
	EOF

	cat >> build/ld/configuration-lib-dynamic.make <<- EOF
ld_lib_type   := shared
	EOF

	cat >> build/import/libfrontend-elements/configuration-dynamic.make <<- EOF
libfrontend_elements_installed := y
	EOF

	cat >> build/import/libxerces-c/configuration-dynamic.make <<- EOF
libxerces_c_installed := y
	EOF

	MAKEOPTS+=" verbose=1"
}

src_install() {
	dolib.so xsd-frontend/libxsd-frontend.so

	find xsd-frontend -iname "*.cxx" \
		-o -iname "makefile" \
		-o -iname "*.o" -o -iname "*.d" \
		-o -iname "*.m4" -o -iname "*.l" \
		-o -iname "*.cpp-options" -o -iname "*.so" | xargs rm -f
	rm -rf xsd-frontend/arch

	insinto /usr/include
	doins -r xsd-frontend

	dodoc NEWS README
}

src_test() {
	export LD_LIBRARY_PATH="${S}/xsd-frontend:${LD_LIBRARY_PATH}"
	default
}
