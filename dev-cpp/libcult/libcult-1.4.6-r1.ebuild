# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs versionator

DESCRIPTION="A collection of C++ libraries"
HOMEPAGE="http://kolpackov.net/projects/libcult/"
SRC_URI="ftp://kolpackov.net/pub/projects/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="examples"

DEPEND="dev-util/build
	sys-devel/m4"
RDEPEND=""

src_prepare() {
	# never build the examples
	sed -i \
		-e 's| $(out_base)/examples/[[:alnum:]\.]*||' \
		-e '/examples\/makefile/d' \
		makefile || die "sed failed"

	epatch "${FILESDIR}/${PV}-fix-compilation-with-gcc-4.7.patch"
	epatch "${FILESDIR}/${P}-cpp14.patch" # bug #593928
}

src_configure() {
	mkdir -p build/{cxx/gnu,ld}

	cat >> build/configuration-dynamic.make <<- EOF
cult_dr := y
cult_threads := y
cult_network := y
	EOF

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

	cat >> build/ld/configuration-lib-dynamic.make <<- EOF
ld_lib_type   := shared
	EOF

	MAKEOPTS+=" verbose=1"
}

src_install() {
	dolib.so cult/libcult.so

	find cult -iname "*.cxx" \
		-o -iname "makefile" \
		-o -iname "*.o" -o -iname "*.d" \
		-o -iname "*.m4" -o -iname "*.l" \
		-o -iname "*.cpp-options" -o -iname "*.so" | xargs rm -f
	rm -rf cult/arch

	insinto /usr/include
	doins -r cult

	dodoc NEWS README documentation/[[:upper:]]*
	dohtml -A xhtml -r documentation/*

	if use examples ; then
		find examples -name makefile -delete
		# preserving symlinks in the examples
		cp -dpR examples "${D}/usr/share/doc/${PF}"
	fi
}
