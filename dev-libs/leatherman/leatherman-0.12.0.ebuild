# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22"

inherit cmake-utils multilib

DESCRIPTION="A C++ toolkit"
HOMEPAGE="https://github.com/puppetlabs/leatherman"
SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug test"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~sparc x86"

RDEPEND="net-misc/curl"
DEPEND=">=dev-libs/boost-1.54[nls]
	net-misc/curl
	>=sys-devel/gcc-4.8:*"

src_prepare() {
	sed -i 's/\-Werror\ //g' "cmake/cflags.cmake" || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_BUILD_TYPE=None
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
		-DCMAKE_INSTALL_LOCALSTATEDIR=/var
	)
	if use debug; then
		mycmakeargs+=(
		  -DCMAKE_BUILD_TYPE=Debug
		)
	fi
	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
}
