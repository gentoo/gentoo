# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/openbabel-perl/openbabel-perl-2.3.2.ebuild,v 1.8 2015/06/28 11:20:25 zlogene Exp $

EAPI=5

inherit cmake-utils eutils perl-module

DESCRIPTION="Perl bindings for OpenBabel"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/openbabel-${PV}.tar.gz"

KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
	dev-lang/perl:=
	~sci-chemistry/openbabel-${PV}"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.8
	>=dev-lang/swig-2"

S="${WORKDIR}/openbabel-${PV}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-trunk_cmake.patch \
		"${FILESDIR}"/${P}-bindings_only.patch
	perl_set_version
}

src_configure() {
	local mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_RPATH=
		-DBINDINGS_ONLY=ON
		-DBABEL_SYSTEM_LIBRARY="${EPREFIX}/usr/$(get_libdir)/libopenbabel.so"
		-DOB_MODULE_PATH="${EPREFIX}/usr/$(get_libdir)/openbabel/${PV}"
		-DLIB_INSTALL_DIR="${D}/${VENDOR_ARCH}"
		-DPERL_BINDINGS=ON
		-DRUN_SWIG=ON"

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile bindings_perl
}

src_test() {
	mkdir "${CMAKE_BUILD_DIR}/$(get_libdir)/Chemistry"
	cp \
		"${CMAKE_USE_DIR}/scripts/perl/OpenBabel.pm" \
		"${CMAKE_BUILD_DIR}/$(get_libdir)/Chemistry/"
	for i in "${CMAKE_USE_DIR}"/scripts/perl/t/*; do
		einfo "Running test: ${i}"
		perl -I"${CMAKE_BUILD_DIR}/$(get_libdir)" "${i}" || die
	done
}

src_install() {
	cd "${CMAKE_BUILD_DIR}"
	cmake -DCOMPONENT=bindings_perl -P cmake_install.cmake
}
