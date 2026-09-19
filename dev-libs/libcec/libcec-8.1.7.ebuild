# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
MY_PV=${PV/_p/-}
MY_P=${PN}-${MY_PV}

inherit cmake dot-a linux-info python-single-r1 udev

DESCRIPTION="Library for communicating with the Pulse-Eight USB HDMI-CEC Adaptor"
HOMEPAGE="https://libcec.pulse-eight.com"
SRC_URI="https://github.com/Pulse-Eight/${PN}/archive/${MY_P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_P}"

LICENSE="GPL-2+"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="exynos kernel-cec python static-libs tools udev +xrandr"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
	udev? ( virtual/udev )
	xrandr? (
		x11-libs/libX11
		x11-libs/libXrandr
	)

"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	python? (
		${PYTHON_DEPS}
		dev-lang/swig
	)
"

CONFIG_CHECK="~USB_ACM"

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

	sed -Ee 's|[ ~]?#DIST#;?||g' debian/changelog.in > ChangeLog || die

	(use tools && use python) || cmake_comment_add_subdirectory "src/pyCecClient"

	if use python; then
		sed -e "s|\${CMAKE_INSTALL_LIBDIR}/python\${PYTHON_VERSION}/\${PYTHON_PKG_DIR}|$(python_get_sitedir)|" \
			-i src/libcec/cmake/CheckPlatformSupport.cmake || die
	fi
}

src_configure() {
	use static-libs && lto-guarantee-fat

	local mycmakeargs=(
		-DDISABLE_CLIENT=$(usex !tools)
		-DDISABLE_STATIC=$(usex !static-libs)
		-DSKIP_PYTHON_WRAPPER=$(usex !python)

		# Same order as in src/libcec/cmake/CheckPlatformSupport.cmake
		-DHAVE_DRM_EDID_PARSER=ON
		-DHAVE_LIBUDEV=$(usex udev)
		-DHAVE_RANDR=$(usex xrandr)
		-DHAVE_RPI_API=OFF
		# bug 922690 and bug 955124
		-DHAVE_TDA995X_API=OFF
		-DHAVE_EXYNOS_API=$(usex exynos)
		-DHAVE_LINUX_API=$(usex kernel-cec)
	)

	if linux_config_exists && linux_chkconfig_present SYSFS; then
		mycmakeargs+=( -DHAVE_P8_USB_DETECT=ON )
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use udev ; then
		sed '/2548/ s/SUBSYSTEM/SUBSYSTEMS/; s/$/, GROUP="video"/;' "${S}/debian/pulse-eight-usb-cec.udev" > \
			"${BUILD_DIR}/65-pulse-eight-usb-cec.rules" || die
	fi
}

src_install() {
	cmake_src_install

	use static-libs && strip-lto-bytecode

	if use python; then
		use tools && python_fix_shebang "${D}"
		python_optimize "${D}$(python_get_sitedir)"
	fi

	use tools && doman debian/cec-client.1

	if use udev; then
		udev_dorules "${BUILD_DIR}/65-pulse-eight-usb-cec.rules"
	fi
}

pkg_postrm() {
	use udev && udev_reload
}

pkg_postinst() {
	use udev && udev_reload

	elog "You will need to ensure the user running your CEC client has"
	elog "read/write access to the device. You can ensure this by adding"
	elog "them to the video group"
}
