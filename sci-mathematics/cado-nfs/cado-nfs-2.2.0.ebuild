# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
DESCRIPTION="Number Field Sieve (NFS) implementation for factoring integers"
HOMEPAGE="http://cado-nfs.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/35401/${P}.tar.gz"

PYTHON_COMPAT=( python{2_7,3_4} )
PYTHON_REQ_USE="sqlite"
inherit eutils cmake-utils python-r1

# Fails F9_{k,m}bucket_test F9_tracektest
RESTRICT="test"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/gmp:0=
	dev-lang/perl
	!sci-mathematics/ggnfs
	!sci-biology/shrimp
	"
DEPEND="${RDEPEND}
	"

src_prepare() {
	# looks like packaging mistake
	sed -i -e 's/add_executable (convert_rels convert_rels.c)//' misc/CMakeLists.txt || die
	sed -i -e 's/target_link_libraries (convert_rels utils)//' misc/CMakeLists.txt || die
	sed -i -e 's~install(TARGETS convert_rels RUNTIME DESTINATION bin/misc)~~' misc/CMakeLists.txt || die
}

src_configure() {
	DESTINATION="/usr/libexec/cado-nfs" cmake-utils_src_configure
}
src_compile() {
	# autodetection goes confused for gf2x
	ABI=default cmake-utils_src_compile
}
