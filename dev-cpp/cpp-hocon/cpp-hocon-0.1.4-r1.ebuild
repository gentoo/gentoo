# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Provides C++ support for the HOCON configuration file format"
HOMEPAGE="https://github.com/puppetlabs/cpp-hocon"
SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 sparc x86"
IUSE="debug test"
RESTRICT="!test? ( test )"

DEPEND="
	>=sys-devel/gcc-4.9.3:*
	>=dev-libs/boost-1.54:=[nls]
	>=dev-libs/leatherman-0.9.3:=
	"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake-utils_src_prepare

	# make it support multilib
	sed -i "s/\ lib)/\ $(get_libdir))/g" lib/CMakeLists.txt || die
	sed -i "s/lib\")/$(get_libdir)\")/g" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_BUILD_TYPE=None
		-DCMAKE_INSTALL_PREFIX=/usr
	)
	if use debug; then
		mycmakeargs+=(
			-DCMAKE_BUILD_TYPE=Debug
		)
	fi
	cmake-utils_src_configure
}
