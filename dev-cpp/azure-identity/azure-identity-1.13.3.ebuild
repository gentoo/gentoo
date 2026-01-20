# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT="1144e4ad18f63bc2084552e1b4fbf737c974261a"
MY_P="azure-sdk-for-cpp-${COMMIT}"
DESCRIPTION="Azure SDK for C++"
HOMEPAGE="https://azure.github.io/azure-sdk-for-cpp/"
SRC_URI="https://github.com/Azure/azure-sdk-for-cpp/archive/${COMMIT}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}/sdk/identity/${PN}"
LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc"
RESTRICT="test" # Too many online tests.

RDEPEND="
	dev-cpp/azure-core:=
	dev-libs/openssl:=
	net-misc/curl[ssl]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DWARNINGS_AS_ERRORS=no
	)

	AZURE_SDK_DISABLE_AUTO_VCPKG=yes \
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm -v "${ED}"/usr/share/*/copyright || die
	use doc && dodoc -r "${BUILD_DIR}"/docs/html
}
