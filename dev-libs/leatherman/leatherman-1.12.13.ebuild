# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A C++ toolkit"
HOMEPAGE="https://github.com/puppetlabs/leatherman"
SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 ~riscv sparc x86"
IUSE="debug static-libs test"
#RESTRICT="!test? ( test )"
RESTRICT="test"  # restricted til we don't need the shared_nowide patch

RDEPEND="dev-libs/boost:=[nls]
	net-misc/curl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/portage-sandbox-test-fix.patch
	"${FILESDIR}"/1.12.2-shared_nowide.patch
)

src_prepare() {
	sed -i 's/\-Werror\ //g' "cmake/cflags.cmake" || die
	# vendored boost lib conflicts with boost 1.73 and above
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_BUILD_TYPE=None
		-DLEATHERMAN_ENABLE_TESTING=$(usex test)
		# We depend on Boost with nls, so this is always true
		-DLEATHERMAN_USE_ICU=ON

		-DLEATHERMAN_SHARED=$(usex !static-libs)
	)

	if use debug; then
		mycmakeargs+=(
			-DCMAKE_BUILD_TYPE=Debug
		)
	fi

	cmake_src_configure
}

src_test() {
	"${WORKDIR}/${P}"_build/bin/leatherman_test || die
}
