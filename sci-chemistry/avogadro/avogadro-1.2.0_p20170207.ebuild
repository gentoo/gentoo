# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=258105b4d8957e0245a341cdf1dc12c72234c833
PYTHON_COMPAT=( python2_7 )
inherit cmake-utils flag-o-matic python-single-r1 vcs-snapshot xdg-utils

DESCRIPTION="Advanced molecular editor that uses Qt4 and OpenGL"
HOMEPAGE="http://avogadro.openmolecules.net/"
SRC_URI="https://github.com/cryos/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="cpu_flags_x86_sse2 +glsl python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	media-libs/glew:=
	sci-chemistry/openbabel:=
	virtual/glu
	x11-libs/gl2ps
	glsl? ( >=media-libs/glew-1.5.0:0= )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:=[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/sip[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	virtual/pkgconfig
"

# https://sourceforge.net/p/avogadro/bugs/653/
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1-mkspecs-dir.patch
	"${FILESDIR}"/${PN}-1.1.1-no-strip.patch
	"${FILESDIR}"/${PN}-1.1.1-pkgconfig_eigen.patch
	"${FILESDIR}"/${PN}-1.1.1-openbabel.patch
	"${FILESDIR}"/${PN}-1.1.1-boost-join-moc.patch
	"${FILESDIR}"/${PN}-1.2.0-numpy.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed -e "s:_BSD_SOURCE:_DEFAULT_SOURCE:g" \
		-i CMakeLists.txt || die

	sed -e "/Version/s/1\.2/1\.0/" \
		-i avogadro/src/avogadro.desktop || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_THREADEDGL=OFF
		-DENABLE_RPATH=OFF
		-DENABLE_UPDATE_CHECKER=OFF
		-DQT_MKSPECS_DIR="${EPREFIX}/usr/share/qt4/mkspecs"
		-DWITH_SSE2=$(usex cpu_flags_x86_sse2)
		-DENABLE_GLSL=$(usex glsl)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_TESTS=$(usex test)
	)

	QT_MKSPECS_RELATIVE=share/qt4/mkspecs cmake-utils_src_configure
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
