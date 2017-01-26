# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs versionator

DESCRIPTION="A compiler frontend for the W3C XML Schema definition language"
HOMEPAGE="http://www.codesynthesis.com/projects/libxsd-frontend/"
SRC_URI="http://www.codesynthesis.com/download/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/xerces-c-3.0.0
	dev-libs/boost:=[threads]
	dev-cpp/libcutl"
DEPEND="${RDEPEND}
	>=dev-util/build-0.3.10"

src_configure() {
	mkdir -p \
		build/{ld,cxx/gnu} \
		build/import/lib{boost,cult,frontend-elements,xerces-c} || die

	cat >> build/cxx/configuration-dynamic.make <<- EOF || die
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

	cat >> build/cxx/gnu/configuration-dynamic.make <<- EOF || die
		cxx_gnu := $(tc-getCXX)
		cxx_gnu_libraries :=
		cxx_gnu_optimization_options :=
	EOF

	cat >> build/ld/configuration-lib-dynamic.make <<- EOF || die
		ld_lib_type   := shared
	EOF

	# boost
	cat >> build/import/libboost/configuration-dynamic.make <<- EOF || die
		libboost_installed := y
		libboost_system := y
	EOF

	# libcutl
	cat >> build/import/libcutl/configuration-dynamic.make <<- EOF || die
		libcutl_installed := y
	EOF

	# xerces-c
	cat >> build/import/libxerces-c/configuration-dynamic.make <<- EOF || die
		libxerces_c_installed := y
	EOF
}

src_compile() {
	emake verbose=1
}

src_install() {
	einstalldocs

	dolib.so xsd-frontend/libxsd-frontend.so

	# clean header dir of build files
	find xsd-frontend \( -iname '*.cxx' -o -iname 'makefile*' \
		-o -iname '*.o' -o -iname '*.d' -o -iname '*.m4' -o -iname '*.l' \
		-o -iname '*.cpp-options' -o -iname '*.so' \) -exec rm -rf '{}' + || die
	rm -rf xsd-frontend/arch || die
	doheader -r xsd-frontend
}

src_test() {
	export LD_LIBRARY_PATH="${S}/xsd-frontend:${LD_LIBRARY_PATH}"
	default
}
