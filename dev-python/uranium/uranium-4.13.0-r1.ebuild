# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{8..10} )

inherit cmake distutils-r1

MY_PN="Uranium"

DESCRIPTION="A Python framework for building 3D printing related applications"
HOMEPAGE="https://github.com/Ultimaker/Uranium"
SRC_URI="https://github.com/Ultimaker/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="debug doc test"

BDEPEND="${PYTHON_DEPS}
	sys-devel/gettext
	doc? ( app-doc/doxygen[dot] )
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/mypy[${PYTHON_USEDEP}]
			dev-python/twisted[${PYTHON_USEDEP}]
		')
	)"

DEPEND="${PYTHON_DEPS}
	>=dev-libs/libarcus-${PV}:=[python,${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/PyQt5[${PYTHON_USEDEP},declarative,network,svg]
		dev-python/numpy[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.1[${PYTHON_USEDEP}]
		sci-libs/shapely[${PYTHON_USEDEP}]
	')"

RDEPEND="${DEPEND}
	dev-qt/qtquickcontrols:5
	dev-qt/qtquickcontrols2:5"

DOCS=( README.md )

S="${WORKDIR}/${MY_PN}-${PV}"

distutils_enable_tests pytest

src_prepare() {
	python_fix_shebang .

	if ! use doc ; then
		sed -i -e '/add_custom_target(doc/d' CMakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCURA_BINARY_DATA_DIRECTORY:STRING="/usr/share/cura/"
		-DGETTEXT_MSGINIT_EXECUTABLE="msginit"
	)

	if ! use debug; then
		sed -i -e 's logging.DEBUG logging.ERROR g' \
		 plugins/ConsoleLogger/ConsoleLogger.py \
		 plugins/FileLogger/FileLogger.py || die
	fi

	sed -i \
		-e "s/find_package(PythonInterp 3 REQUIRED/find_package(Python3 ${EPYTHON##python} EXACT REQUIRED COMPONENTS Interpreter/g" \
		CMakeLists.txt cmake/UraniumPluginInstall.cmake

	sed -i \
		-e "s/find_package(Python3 REQUIRED/find_package(Python3 ${EPYTHON##python} EXACT REQUIRED/g" \
		-e 's/set(Python3_EXECUTABLE ${PYTHON_EXECUTABLE})//g' \
		cmake/UraniumPluginInstall.cmake

	sed -i \
		-e "s lib\${LIB_SUFFIX}/python\${PYTHON_VERSION_MAJOR}.\${PYTHON_VERSION_MINOR}/site-packages $(python_get_sitedir) g" \
		-e 's cmake-${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} cmake g' \
		CMakeLists.txt

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install

	python_optimize "${ED}"/usr
}
