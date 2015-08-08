# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="gnuradio fosphor block (GPU spectrum display)"
HOMEPAGE="https://sdr.osmocom.org/trac/wiki/fosphor"

if [[ ${PV} == 9999* ]]; then
	inherit git-2
	SRC_URI=""
	EGIT_REPO_URI="git://git.osmocom.org/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="mirror://gentoo/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+glfw qt4 wxwidgets"

RDEPEND="qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
	)
	>=net-wireless/gnuradio-3.7_rc:0=[qt4?,wxwidgets?,${PYTHON_USEDEP}]
	media-libs/freetype
	dev-libs/boost:=
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
	python_fix_shebang python/wx_sink_c.py
	cmake-utils_src_prepare
}

src_configure() {
	# tries to run OpenCL test program, but failing doesn't hurt
	addpredict /dev/dri

	local mycmakeargs="
		$(cmake-utils_use_enable glfw GLFW)
		$(cmake-utils_use_enable qt4 QT)
		$(cmake-utils_use_enable wxwidgets WX)
		-DENABLE_PYTHON=ON
	"
	cmake-utils_src_configure
}
