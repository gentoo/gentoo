# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gflags/gflags-9999.ebuild,v 1.1 2014/07/17 00:27:58 floppym Exp $

EAPI="5"

inherit cmake-multilib

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://code.google.com/p/gflags/"
else
	SRC_URI="https://github.com/schuhschuh/gflags/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Google's C++ argument parsing library"
HOMEPAGE="http://code.google.com/p/gflags/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

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
