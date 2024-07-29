# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="A multi-platform library for USB and Bluetooth HID-Class devices"
HOMEPAGE="https://github.com/libusb/hidapi"
SRC_URI="https://github.com/libusb/hidapi/archive/${P}.tar.gz -> ${P}.tgz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="|| ( BSD GPL-3 HIDAPI )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc"

DEPEND="
	virtual/libusb:1[${MULTILIB_USEDEP}]
	virtual/libudev:0[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( app-text/doxygen )"

multilib_src_configure() {
	append-lfs-flags

	local mycmakeargs=(
		# Doesn't do anything as of 0.14.0
		-DHIDAPI_WITH_TESTS=OFF
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile

	if use doc && multilib_is_native_abi; then
		cd "${S}/doxygen" || die
		doxygen Doxyfile || die
	fi
}

multilib_src_install() {
	cmake_src_install

	if use doc && multilib_is_native_abi; then
		local HTML_DOCS=( "${S}/doxygen/html/." )
	fi
	einstalldocs
}
