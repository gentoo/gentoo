# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils eutils

DESCRIPTION="GNUstep Objective-C runtime"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="https://github.com/gnustep/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boehm-gc test"
RESTRICT="!test? ( test )"

RDEPEND="boehm-gc? ( dev-libs/boehm-gc )
	sys-libs/libcxx"
BDEPEND="${RDEPEND}
	sys-devel/clang"

src_configure() {
	export CC="clang"
	export CXX="clang++"
	local mycmakeargs=(
		-DGNUSTEP_CONFIG=GNUSTEP_CONFIG-NOTFOUND
		-DBOEHM_GC="$(usex boehm-gc)"
		-DTESTS="$(usex test)"
	)
	cmake-utils_src_configure
}
