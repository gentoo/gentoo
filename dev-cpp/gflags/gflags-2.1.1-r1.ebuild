# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-multilib

DESCRIPTION="Google's C++ argument parsing library"
HOMEPAGE="http://gflags.github.io/gflags/"
SRC_URI="https://github.com/schuhschuh/gflags/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

PATCHES=( "${FILESDIR}/gflags-2.1.1-libs.patch" )

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		$(cmake-utils_use_build static-libs STATIC_LIBS)
	)

	cmake-utils_src_configure
}

multilib_src_install_all() {
	rm -rf "${ED}"/usr/share/doc
	dodoc {AUTHORS,ChangeLog,NEWS,README}.txt
	dohtml doc/*
}
