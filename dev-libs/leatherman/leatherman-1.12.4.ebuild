# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils multilib

DESCRIPTION="A C++ toolkit"
HOMEPAGE="https://github.com/puppetlabs/leatherman"
SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
IUSE="debug static-libs test"
#RESTRICT="!test? ( test )"
RESTRICT="test"  # restricted til we don't need the shared_nowide patch
KEYWORDS="amd64 ~arm ~hppa ppc ppc64 sparc x86"
SLOT="0/${PV}"

RDEPEND="net-misc/curl"
DEPEND=">=dev-libs/boost-1.73:=[nls]
	net-misc/curl
	>=sys-devel/gcc-4.8:*"

PATCHES=( "${FILESDIR}"/portage-sandbox-test-fix.patch )
PATCHES+=( "${FILESDIR}"/1.12.2-shared_nowide.patch )

src_prepare() {
	sed -i 's/\-Werror\ //g' "cmake/cflags.cmake" || die
	# vendored boost lib conflicts with boost 1.73 and above
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_BUILD_TYPE=None
	)
	if ! use static-libs; then
		mycmakeargs+=(
			-DLEATHERMAN_SHARED=ON
		)
	else
		mycmakeargs+=(
			-DLEATHERMAN_SHARED=OFF
		)
	fi
	if use debug; then
		mycmakeargs+=(
		  -DCMAKE_BUILD_TYPE=Debug
		)
	fi
	cmake-utils_src_configure
}

src_test() {
	"${WORKDIR}/${P}"_build/bin/leatherman_test
}

src_install() {
	cmake-utils_src_install
}
