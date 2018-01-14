# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils multilib python-single-r1 virtualx

DESCRIPTION="Library for chemistry applications"
HOMEPAGE="http://www.chemkit.org/"
SRC_URI="mirror://sourceforge/project/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD PSF-2.2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples python qt4 test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	test? ( python qt4 )"

RDEPEND="
	dev-libs/boost
	dev-libs/rapidxml
	dev-cpp/eigen:3
	media-libs/glu
	sci-libs/inchi
	sci-libs/lemon
	virtual/opengl
	examples? (
		x11-libs/libX11
		x11-libs/libXext
	)
	python? ( ${PYTHON_DEPS} )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
	)
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-unbundle.patch
)

src_prepare() {
	# jsoncpp API change
	# xdrf != xdrfile
	rm -rvf src/3rdparty/{inchi,khronos,lemon,rapidxml} || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCHEMKIT_BUILD_APPS=$(usex qt4)
		-DCHEMKIT_BUILD_PLUGIN_BABEL=$(usex qt4)
		-DCHEMKIT_BUILD_QT_DESIGNER_PLUGINS=$(usex qt4)
		-DCHEMKIT_WITH_GRAPHICS=$(usex qt4)
		-DCHEMKIT_WITH_GUI=$(usex qt4)
		-DCHEMKIT_WITH_WEB=$(usex qt4)
		-DUSE_SYSTEM_INCHI=ON
		-DUSE_SYSTEM_JSONCPP=OFF
		-DUSE_SYSTEM_RAPIDXML=ON
		-DUSE_SYSTEM_XDRF=OFF
		$(cmake-utils_use examples CHEMKIT_BUILD_EXAMPLES)
		$(cmake-utils_use examples CHEMKIT_BUILD_DEMOS)
		$(cmake-utils_use python CHEMKIT_BUILD_BINDINGS_PYTHON)
		$(cmake-utils_use test CHEMKIT_BUILD_TESTS)
	)
	cmake-utils_src_configure
}

src_test() {
	VIRTUALX_COMMAND="cmake-utils_src_test"
	virtualmake
}

src_install() {
	use examples && \
		dobin \
			"${BUILD_DIR}"/demos/*-viewer/*-viewer \
			"${BUILD_DIR}"/examples/uff-energy/uff-energy

	cmake-utils_src_install
}
