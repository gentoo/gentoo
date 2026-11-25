# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="Fork of dev-libs/hidapi with hotplug support"
HOMEPAGE="https://codeberg.org/OpenRGB/hidapi-hotplug"
SRC_URI="https://codeberg.org/OpenRGB/hidapi-hotplug/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="|| ( BSD GPL-3 HIDAPI )"
SLOT="0"
KEYWORDS="~amd64"
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
