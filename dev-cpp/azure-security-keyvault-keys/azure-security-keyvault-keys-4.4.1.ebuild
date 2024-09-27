# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT="1d22b9bc578fec09364f7271ff7bd679d713e1f2"
MY_P="azure-sdk-for-cpp-${COMMIT}"
DESCRIPTION="Azure SDK for C++"
HOMEPAGE="https://azure.github.io/azure-sdk-for-cpp/"
SRC_URI="https://github.com/Azure/azure-sdk-for-cpp/archive/${COMMIT}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}/sdk/keyvault/${PN}"
LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc"
RESTRICT="test" # Too many online tests.

RDEPEND="
	dev-cpp/azure-core:=
	net-misc/curl[ssl]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

src_prepare() {
	cmake_src_prepare
	cd ../../.. || die
	eapply "${FILESDIR}"/azure-sdk-for-cpp-doc-assets-dir.patch
	eapply "${FILESDIR}"/azure-sdk-for-cpp-soversion.patch
}

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
