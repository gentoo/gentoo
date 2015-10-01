# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils

DESCRIPTION="GNUstep Objective-C runtime"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="https://github.com/gnustep/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boehm-gc cxx test"

RDEPEND="boehm-gc? ( dev-libs/boehm-gc )
	cxx? ( sys-libs/libcxx )"
DEPEND="${DEPEND}
	>=sys-devel/clang-2.9"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.7-fix_soname.patch

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
