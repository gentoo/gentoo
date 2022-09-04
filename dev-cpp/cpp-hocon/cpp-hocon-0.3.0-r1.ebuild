# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake prefix

DESCRIPTION="Provides C++ support for the HOCON configuration file format"
HOMEPAGE="https://github.com/puppetlabs/cpp-hocon"
SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc x86"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=[nls]
	>=dev-libs/leatherman-0.9.3:=
"
DEPEND="${DEPEND}
	test? ( dev-cpp/catch:1 )"

#PATCHES=( "${FILESDIR}"/${PN}-0.2.1-cmake.patch )
PATCHES=( "${FILESDIR}"/${PN}-0.3.0-use-system-catch.patch )

src_prepare() {
	cmake_src_prepare

	eprefixify lib/tests/CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
