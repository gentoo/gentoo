# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
MY_PV=${PV/_p/-}
MY_P=${PN}-${MY_PV}

inherit cmake linux-info python-single-r1 toolchain-funcs udev

DESCRIPTION="Library for communicating with the Pulse-Eight USB HDMI-CEC Adaptor"
HOMEPAGE="http://libcec.pulse-eight.com"
SRC_URI="https://github.com/Pulse-Eight/${PN}/archive/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"
IUSE="cubox exynos python raspberry-pi kernel-cec tools +xrandr udev"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/libplatform-2.0.0
	python? ( ${PYTHON_DEPS} )
	raspberry-pi? ( >=media-libs/raspberrypi-userland-0_pre20160305-r1 )
	tools? ( sys-libs/ncurses:= )
	udev? ( virtual/udev )
	xrandr? ( x11-libs/libXrandr )
"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~USB_ACM"

S="${WORKDIR}/${PN}-${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.7-no-override-udev.patch"
	"${FILESDIR}/${PN}-6.0.2-musl-nullptr.patch"
)

pkg_pretend() {
	use udev || CONFIG_CHECK+=" ~SYSFS"
	ERROR_SYSFS="When using libcec build without udev, kernel config option CONFIG_SYSFS is required to automatically detect P8 USB-CEC adapter port number"

	linux-info_pkg_setup
}

pkg_setup() {
	linux-info_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# Do not hardcode the python libpath #577612
	sed -i \
		-e '/DESTINATION/s:"lib/python${PYTHON_VERSION}/${PYTHON_PKG_DIR}":${PYTHON_SITEDIR}:' \
		src/libcec/cmake/CheckPlatformSupport.cmake || die

	sed -Ee 's|[ ~]?#DIST#;?||g' debian/changelog.in > ChangeLog || die

	(use tools && use python) || cmake_comment_add_subdirectory "src/pyCecClient"

	if ! use tools; then
		cmake_comment_add_subdirectory "src/cec-client"
		cmake_comment_add_subdirectory "src/cecc-client"
		sed -i -Ee 's|add_dependencies\(cecc?-client cec\)|#DO NOT BUILD \0|' \
			CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DHAVE_LINUX_API=$(usex kernel-cec ON OFF)
		-DHAVE_LIBUDEV=$(usex udev ON OFF)
		-DSKIP_PYTHON_WRAPPER=$(usex python OFF ON)
		-DHAVE_EXYNOS_API=$(usex exynos ON OFF)
		-DHAVE_TDA995X_API=$(usex cubox ON OFF)
		-DHAVE_RPI_API=$(usex raspberry-pi ON OFF)
	)

	if linux_config_exists && linux_chkconfig_present SYSFS; then
		mycmakeargs+=( -DHAVE_P8_USB_DETECT=ON )
	fi

	# raspberrypi-userland itself does not provide .pc file so using
	# bcm_host.pc instead
	use raspberry-pi && mycmakeargs+=(
		-DRPI_INCLUDE_DIR=$( $(tc-getPKG_CONFIG) --variable=includedir bcm_host) \
		-DRPI_LIB_DIR=$( $(tc-getPKG_CONFIG) --variable=libdir bcm_host)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use udev ; then
		cp "${S}/debian/pulse-eight-usb-cec.udev" \
			"${BUILD_DIR}/65-pulse-eight-usb-cec.udev" || die
	fi
}

src_install() {
	cmake_src_install

	use python && python_optimize "${D}$(python_get_sitedir)"

	use tools && doman debian/cec-client.1

	if use udev; then
		udev_dorules "${BUILD_DIR}/65-pulse-eight-usb-cec.udev"
	fi
}

pkg_postinst() {
	use udev && udev_reload

	elog "You will need to ensure the user running your CEC client has"
	elog "read/write access to the device. You can ensure this by adding"
	elog "them to the uucp group"
}
