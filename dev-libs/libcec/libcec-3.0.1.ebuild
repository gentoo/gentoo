# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit cmake-utils eutils linux-info python-single-r1

DESCRIPTION="Library for communicating with the Pulse-Eight USB HDMI-CEC Adaptor"
HOMEPAGE="http://libcec.pulse-eight.com"
SRC_URI="https://github.com/Pulse-Eight/${PN}/archive/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"

IUSE="cubox exynos python raspberry-pi +xrandr"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="virtual/udev
	dev-libs/lockdev
	dev-libs/libplatform
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? (
		dev-lang/swig
		${PYTHON_DEPS}
	)"

CONFIG_CHECK="~USB_ACM"

S="${WORKDIR}/${PN}-${P}"

PATCHES=( "${FILESDIR}"/${P}-envcheck.patch )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare
	use python || comment_add_subdirectory "src/pyCecClient"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_useno python SKIP_PYTHON_WRAPPER)
		$(cmake-utils_use_has exynos EXYNOS_API) \
		$(cmake-utils_use_has cubox TDA955X_API)
		$(cmake-utils_use_has raspberry-pi RPI_API)
	)
	cmake-utils_src_configure
}
