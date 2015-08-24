# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit cmake-utils eutils python-r1

DESCRIPTION="A HTML/CSS User Interface library"
HOMEPAGE="http://librocket.com/"
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="python samples"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="media-libs/freetype
	python? (
		${PYTHON_DEPS}
		dev-libs/boost[python]
	)
	samples? (
		virtual/opengl
		x11-libs/libXext
		x11-libs/libX11
	)"
DEPEND="${RDEPEND}"

python_BUILD_DIR=${WORKDIR}/${P}_build_python
CMAKE_USE_DIR="${S}"/Build

src_configure() {
	local mycmakeargs=(
		-DBUILD_PYTHON_BINDINGS=OFF
		$(cmake-utils_use_build samples SAMPLES)
		-DSAMPLES_DIR=/usr/share/${PN}/samples
	)

	cmake-utils_src_configure

	if use python ; then
		cfgpybind() {
			local mycmakeargs=(
				-DBUILD_PYTHON_BINDINGS=ON
				-DCMAKE_SKIP_RPATH=YES
			)
			BUILD_DIR="${python_BUILD_DIR}-${EPYTHON}" cmake-utils_src_configure
		}
		einfo "configuring python binding"
		python_foreach_impl cfgpybind
	fi
}

src_compile() {
	cmake-utils_src_compile

	if use python ; then
		buildpybind() {
			cp "${WORKDIR}"/${P}_build/{libRocketCore*,libRocketControls*} "${python_BUILD_DIR}-${EPYTHON}"/ || die
			BUILD_DIR="${python_BUILD_DIR}-${EPYTHON}" cmake-utils_src_make _rocketcontrols/fast _rocketcore/fast
		}
		einfo "compiling python binding"
		python_foreach_impl buildpybind
	fi
}

src_install() {
	cmake-utils_src_install

	if use python ; then
		instpybind() {
			python_domodule bin/rocket.py
			exeinto "$(python_get_sitedir)"
			doexe ${python_BUILD_DIR}-${EPYTHON}/_rocket{core,controls}.so
		}
		einfo "installing python binding"
		python_foreach_impl instpybind
	fi
}
