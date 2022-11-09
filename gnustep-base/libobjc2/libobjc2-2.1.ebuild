# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="GNUstep Objective-C runtime"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="https://github.com/gnustep/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Tessil/robin-map/archive/757de82.tar.gz"

LICENSE="MIT"
SLOT="0"
QA_PKGCONFIG_VERSION="2.0.0"
KEYWORDS="~amd64 ~x86"
IUSE="boehm-gc test"
RESTRICT="!test? ( test )"

RDEPEND="boehm-gc? ( dev-libs/boehm-gc )"
BDEPEND="${RDEPEND}
	sys-devel/clang"

PATCHES=(
	"${FILESDIR}"/${P}-eh_trampoline.patch
	"${FILESDIR}"/${P}-pthread_link.patch
)

src_prepare() {
	cmake_src_prepare
	cp -a "${WORKDIR}"/robin-map-757de829927489bee55ab02147484850c687b620/* \
		"${S}"/third_party/robin-map || die
}

src_configure() {
	export CC="clang"
	export CXX="clang++"
	local mycmakeargs=(
		-DGNUSTEP_CONFIG=GNUSTEP_CONFIG-NOTFOUND
		-DBOEHM_GC="$(usex boehm-gc)"
		-DTESTS="$(usex test)"
	)
	cmake_src_configure
}
