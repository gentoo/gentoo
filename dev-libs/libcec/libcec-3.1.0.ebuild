# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_4 )

inherit cmake-utils eutils linux-info python-single-r1

DESCRIPTION="Library for communicating with the Pulse-Eight USB HDMI-CEC Adaptor"
HOMEPAGE="http://libcec.pulse-eight.com"
SRC_URI="https://github.com/Pulse-Eight/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="cubox exynos python raspberry-pi +xrandr"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="virtual/udev
	dev-libs/libplatform
	raspberry-pi? ( >=media-libs/raspberrypi-userland-0_pre20160305-r1 )
	python? ( ${PYTHON_DEPS} )
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? ( dev-lang/swig )"

CONFIG_CHECK="~USB_ACM"

S="${WORKDIR}/${PN}-${P}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Do not hardcode the python libpath #577612
	sed -i \
		-e '/DESTINATION/s:lib/python${PYTHON_VERSION}/dist-packages:${PYTHON_SITEDIR}:' \
		src/libcec/cmake/CheckPlatformSupport.cmake || die

	cmake-utils_src_prepare
	use python || comment_add_subdirectory "src/pyCecClient"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_useno python SKIP_PYTHON_WRAPPER)
		$(cmake-utils_use_has exynos EXYNOS_API)
		$(cmake-utils_use_has cubox TDA955X_API)
		$(cmake-utils_use_has raspberry-pi RPI_API)
	)
	use python && mycmakeargs+=( -DPYTHON_SITEDIR="$(python_get_sitedir)" )

	# raspberrypi-userland itself does not provide .pc file so using
	# bcm_host.pc instead
	if use raspberry-pi ; then
		mycmakeargs+=( \
			-DRPI_INCLUDE_DIR=$(pkg-config --variable=includedir bcm_host) \
			-DRPI_LIB_DIR=$(pkg-config --variable=libdir bcm_host) )
	fi

	cmake-utils_src_configure
}
