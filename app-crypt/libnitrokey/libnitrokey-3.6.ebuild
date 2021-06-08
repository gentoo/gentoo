# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev cmake

DESCRIPTION="Support library for the Nitrokey"
HOMEPAGE="https://github.com/Nitrokey/libnitrokey"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Nitrokey/libnitrokey.git"

	# Disable pulling in bundled dependencies
	EGIT_SUBMODULES=()
else
	SRC_URI="https://github.com/Nitrokey/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~ppc64 x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/hidapi:=
	virtual/udev"
DEPEND="
	${RDEPEND}
	test? ( >=dev-cpp/catch-2.5.0:0 )"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_UDEVRULESDIR="$(get_udevdir)"/rules.d

		# actual hardware tests
		#   1. require a connected Nitrokey
		#   2. may kill data on your Nitrokey
		# hence the main testsuite is disabled
		-DCOMPILE_TESTS=OFF
		-DCOMPILE_OFFLINE_TESTS=$(usex test)
	)
	cmake_src_configure
}
