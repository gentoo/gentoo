# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils perl-module

DESCRIPTION="Perl bindings for OpenBabel"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/openbabel-${PV}.tar.gz"

KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
SLOT="0/5"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
	dev-lang/perl:=
	~sci-chemistry/openbabel-${PV}"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.8
	>=dev-lang/swig-2"

S="${WORKDIR}/openbabel-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.2-gcc-6_and_7-backport.patch
)

src_prepare() {
	sed \
		-e '/__GNUC__/s:== 4:>= 4:g' \
		-i include/openbabel/shared_ptr.h || die
	cmake-utils_src_prepare
	perl_set_version
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_RPATH=
		-DBINDINGS_ONLY=ON
		-DBABEL_SYSTEM_LIBRARY="${EPREFIX}/usr/$(get_libdir)/libopenbabel.so"
		-DOB_MODULE_PATH="${EPREFIX}/usr/$(get_libdir)/openbabel/${PV}"
		-DLIB_INSTALL_DIR="${D}/${VENDOR_ARCH}"
		-DPERL_BINDINGS=ON
		-DRUN_SWIG=ON
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile bindings_perl
}

src_test() {
	mkdir "${CMAKE_BUILD_DIR}/$(get_libdir)/Chemistry" || die
	cp \
		"${CMAKE_USE_DIR}/scripts/perl/OpenBabel.pm" \
		"${CMAKE_BUILD_DIR}/$(get_libdir)/Chemistry/" || die
	for i in "${CMAKE_USE_DIR}"/scripts/perl/t/*; do
		einfo "Running test: ${i}"
		perl -I"${CMAKE_BUILD_DIR}/$(get_libdir)" "${i}" || die
	done
}

src_install() {
	cd "${CMAKE_BUILD_DIR}" || die
	cmake -DCOMPONENT=bindings_perl -P cmake_install.cmake
}
