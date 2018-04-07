# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1 virtualx

DESCRIPTION="Library for chemistry applications"
HOMEPAGE="https://github.com/kylelutz/chemkit"
SRC_URI="mirror://sourceforge/project/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD PSF-2.2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples python test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost:=
	dev-libs/rapidxml
	media-libs/glu
	sci-libs/inchi
	sci-libs/lemon
	virtual/opengl
	examples? (
		x11-libs/libX11
		x11-libs/libXext
	)
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"

RESTRICT="test" # requires disabled Qt4

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

	# bug 640206
	sed -e "/add_subdirectory(xtc/s/^/#DONT /" \
		-i src/plugins/CMakeLists.txt || die "Failed to disable xtc"
}

src_configure() {
	local mycmakeargs=(
		-DCHEMKIT_BUILD_EXAMPLES=$(usex examples)
		-DCHEMKIT_BUILD_DEMOS=$(usex examples)
		-DCHEMKIT_BUILD_BINDINGS_PYTHON=$(usex python)
		-DCHEMKIT_BUILD_APPS=OFF
		-DCHEMKIT_BUILD_PLUGIN_BABEL=OFF
		-DCHEMKIT_BUILD_QT_DESIGNER_PLUGINS=OFF
		-DCHEMKIT_WITH_GRAPHICS=OFF
		-DCHEMKIT_WITH_GUI=OFF
		-DCHEMKIT_WITH_WEB=OFF
		-DCHEMKIT_BUILD_TESTS=$(usex test)
		-DUSE_SYSTEM_INCHI=ON
		-DUSE_SYSTEM_JSONCPP=OFF
		-DUSE_SYSTEM_RAPIDXML=ON
		-DUSE_SYSTEM_XDRF=OFF
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
