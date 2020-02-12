# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="Config database to store, share and manipulate colour management informations"
HOMEPAGE="https://github.com/OpenICC/config"
SRC_URI="https://github.com/OpenICC/config/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-devel/gettext
	doc? ( app-doc/doxygen )
"
DEPEND="
	dev-libs/yajl[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

REQUIRED_USE="test? ( static-libs )"

PATCHES=( "${FILESDIR}/${P}"-buildsystem.patch )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/openicc/openicc_version.h
)

S="${WORKDIR}/config-${PV}"

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC_LIBS=$(usex static-libs)
		-DENABLE_TESTS=$(usex test)
		$(multilib_is_native_abi || echo -DENABLE_TOOLS=OFF )
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(multilib_native_usex doc OFF ON)
	)

	cmake_src_configure
}
