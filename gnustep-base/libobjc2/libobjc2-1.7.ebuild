# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/libobjc2/libobjc2-1.7.ebuild,v 1.2 2013/09/27 20:09:55 voyageur Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="GNUstep Objective-C runtime"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="http://download.gna.org/gnustep/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boehm-gc cxx test"

RDEPEND="boehm-gc? ( dev-libs/boehm-gc )
	cxx? ( sys-libs/libcxx )"
DEPEND="${DEPEND}
	>=sys-devel/clang-2.9"

src_prepare() {
	if ! use cxx;
	then
		sed -e 's/addtest_flags(CXXExceptions.*//' \
			-i Test/CMakeLists.txt || die "test sed failed"
	fi
}

src_configure() {
	export CC=clang
	export CXX=clang++

	export PREFIX=/usr
	local mycmakeargs=(
		-DGNUSTEP_CONFIG=GNUSTEP_CONFIG-NOTFOUND
		$(cmake-utils_use boehm-gc BOEHM_GC)
		$(cmake-utils_use_enable cxx OBJCXX)
		$(cmake-utils_use test TESTS)
	)
	cmake-utils_src_configure
}
