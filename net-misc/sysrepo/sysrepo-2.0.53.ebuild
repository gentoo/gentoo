# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="YANG-based configuration and operational state data store"
HOMEPAGE="https://www.sysrepo.org"
SRC_URI="https://github.com/sysrepo/sysrepo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND=">=net-libs/libyang-2.0.112:="
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen[dot] )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTS=$(usex test)
		-DENABLE_VALGRIND_TESTS=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install

	use doc && dodoc -r doc/.
}
