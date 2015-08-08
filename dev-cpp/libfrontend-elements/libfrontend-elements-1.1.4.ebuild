# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs versionator

DESCRIPTION="A collection of elementary building blocks for implementing compiler frontends in c++"
HOMEPAGE="http://kolpackov.net/projects/libfrontend-elements/"
SRC_URI="ftp://kolpackov.net/pub/projects/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="examples"

RDEPEND=">=dev-cpp/libcult-1.4.6-r1"
DEPEND="${RDEPEND}
	dev-util/build:0.3"

src_prepare() {
	# never build the examples
	sed -i \
		-e 's| $(out_base)/examples/[[:alnum:]\.]*||' \
		-e '/examples\/makefile/d' \
		makefile || die "sed failed"
}

src_configure() {
	mkdir -p build/{ld,cxx/gnu,import/libcult}

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

	cat >> build/import/libcult/configuration-dynamic.make <<- EOF
libcult_installed := y
	EOF

	cat >> build/ld/configuration-lib-dynamic.make <<- EOF
ld_lib_type   := shared
	EOF

	MAKEOPTS+=" verbose=1"
}

src_install() {
	dolib.so frontend-elements/libfrontend-elements.so

	find frontend-elements -iname "*.cxx" \
		-o -iname "makefile" \
		-o -iname "*.o" -o -iname "*.d" \
		-o -iname "*.m4" -o -iname "*.l" \
		-o -iname "*.cpp-options" -o -iname "*.so" | xargs rm -f
	rm -rf frontend-elements/arch

	insinto /usr/include
	doins -r frontend-elements

	dodoc NEWS README documentation/[[:upper:]]*
	dohtml -A xhtml -r documentation/*

	if use examples ; then
		find examples -name makefile -delete
		# preserving symlinks in the examples
		cp -dpR examples "${D}/usr/share/doc/${PF}"
	fi
}
