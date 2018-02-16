# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib

DESCRIPTION="A C++ toolkit"
HOMEPAGE="https://github.com/puppetlabs/leatherman"
SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug static-libs test"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
SLOT="1.4"

RDEPEND="net-misc/curl"
DEPEND=">=dev-libs/boost-1.54:=[nls]
	net-misc/curl
	>=sys-devel/gcc-4.8:*"

PATCHES=( "${FILESDIR}"/portage-sandbox-test-fix.patch )

src_prepare() {
	sed -i 's/\-Werror\ //g' "cmake/cflags.cmake" || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_BUILD_TYPE=None
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
		-DCMAKE_INSTALL_LOCALSTATEDIR=/var
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
