# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..13} )

inherit cmake python-single-r1

DESCRIPTION="gnuradio fosphor block (GPU spectrum display)"
HOMEPAGE="https://sdr.osmocom.org/trac/wiki/fosphor"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/osmocom/${PN}.git"
else
	COMMIT="974ab2fe54c25e8b6c37aa4de148ba0625eef652"
	SRC_URI="https://github.com/osmocom/gr-fosphor/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="glfw qt5"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-libs/boost:=
	dev-libs/log4cpp
	media-libs/freetype
	>=net-wireless/gnuradio-3.9:0=[qt5,${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep 'dev-python/pygccxml[${PYTHON_USEDEP}]')
	glfw? ( >=media-libs/glfw-3 )
	virtual/opencl
	virtual/opengl
	${PYTHON_DEPS}
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}"
BDEPEND="$(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]')"

PATCHES=( "${FILESDIR}"/${PN}-0.0_p20200131-htmldir.patch
		  "${FILESDIR}"/${P}-fix-use.patch )

src_prepare() {
	cmake_src_prepare

	# adapt python bindings to use flags
	use glfw || sed -i -e "s#bind_glfw_sink_c(m)##" \
					"${S}"/python/bindings/python_bindings.cc ||die
	use qt5 || sed -i -e "s#bind_qt_sink_c(m)##" \
					"${S}"/python/bindings/python_bindings.cc ||die

	eapply_user
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
	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${D}" -name '*.py[oc]' -delete || die
	python_optimize
}
