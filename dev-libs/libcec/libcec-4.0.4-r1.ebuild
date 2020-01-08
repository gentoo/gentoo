# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} )
MY_PV=${PV/_p/-}
MY_P=${PN}-${MY_PV}

inherit cmake-utils linux-info python-single-r1 toolchain-funcs

DESCRIPTION="Library for communicating with the Pulse-Eight USB HDMI-CEC Adaptor"
HOMEPAGE="http://libcec.pulse-eight.com"
SRC_URI="https://github.com/Pulse-Eight/${PN}/archive/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="cubox exynos python raspberry-pi +xrandr"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="virtual/udev
	>=dev-libs/libplatform-2.0.0
	sys-libs/ncurses:=
	raspberry-pi? ( >=media-libs/raspberrypi-userland-0_pre20160305-r1 )
	xrandr? ( x11-libs/libXrandr )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	virtual/pkgconfig"

CONFIG_CHECK="~USB_ACM"

S="${WORKDIR}/${PN}-${MY_P}"

pkg_pretend() {
	linux-info_pkg_setup
}

pkg_setup() {
	linux-info_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	# Do not hardcode the python libpath #577612
	sed -i \
		-e '/DESTINATION/s:lib/python${PYTHON_VERSION}/dist-packages:${PYTHON_SITEDIR}:' \
		src/libcec/cmake/CheckPlatformSupport.cmake || die

	use python || cmake_comment_add_subdirectory "src/pyCecClient"
}

src_configure() {
	local mycmakeargs=(
		-DSKIP_PYTHON_WRAPPER=$(usex !python)
		-DHAVE_EXYNOS_API=$(usex exynos)
		-DHAVE_TDA995X_API=$(usex cubox)
		-DHAVE_RPI_API=$(usex raspberry-pi)
	)

	# raspberrypi-userland itself does not provide .pc file so using
	# bcm_host.pc instead
	use raspberry-pi && mycmakeargs+=(
		-DRPI_INCLUDE_DIR=$( $(tc-getPKG_CONFIG) --variable=includedir bcm_host) \
		-DRPI_LIB_DIR=$( $(tc-getPKG_CONFIG) --variable=libdir bcm_host)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	elog "You will need to ensure the user running your CEC client has"
	elog "read/write access to the device. You can ensure this by adding"
	elog "them to the uucp group"
}
