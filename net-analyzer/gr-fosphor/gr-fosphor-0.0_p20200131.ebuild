# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake-utils python-single-r1

DESCRIPTION="gnuradio fosphor block (GPU spectrum display)"
HOMEPAGE="https://sdr.osmocom.org/trac/wiki/fosphor"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/osmocom/${PN}.git"
else
	COMMIT="defdd4aca6cd157ccc3b10ea16b5b4f552f34b96"
	SRC_URI="https://github.com/osmocom/gr-fosphor/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

LICENSE="GPL-3+"
SLOT="0"
IUSE="glfw qt5"

RDEPEND="qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
	)
	dev-libs/boost:=
	dev-libs/log4cpp
	media-libs/freetype
	=net-wireless/gnuradio-3.8*:0=[qt5,${PYTHON_SINGLE_USEDEP}]
	glfw? ( >=media-libs/glfw-3 )
	virtual/opencl
	virtual/opengl
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	dev-lang/swig:0
	dev-util/cppunit
"

src_prepare() {
	cmake-utils_src_prepare
	default
}

src_configure() {
	# tries to run OpenCL test program, but failing doesn't hurt
	addpredict /dev/dri

	local mycmakeargs=(
		-DENABLE_DEFAULT=OFF
		-DENABLE_GLFW="$(usex glfw)"
		-DENABLE_QT="$(usex qt5)"
		-DENABLE_PYTHON=ON
	)
	cmake-utils_src_configure
}
