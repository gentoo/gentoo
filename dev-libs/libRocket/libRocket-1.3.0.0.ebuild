# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit cmake-utils eutils python-r1 multilib-minimal

DESCRIPTION="A HTML/CSS User Interface library"
HOMEPAGE="http://librocket.com/"
SRC_URI="https://github.com/libRocket/libRocket/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="python samples"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}]
	python? (
		${PYTHON_DEPS}
		dev-libs/boost[${PYTHON_USEDEP}]
	)
	samples? (
		virtual/opengl
		x11-libs/libXext
		x11-libs/libX11
	)"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-release-${PV}

DOCS=( changelog.txt readme.md )

python_BUILD_DIR=${WORKDIR}/${P}_build_python
CMAKE_USE_DIR="${S}"/Build

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_PYTHON_BINDINGS=OFF
		-DSAMPLES_DIR=/usr/share/${PN}/samples
	)

	if multilib_is_native_abi ; then
		mycmakeargs+=( $(cmake-utils_use_build samples SAMPLES) )
	else
		mycmakeargs+=( -DBUILD_SAMPLES=OFF )
	fi

	cmake-utils_src_configure

	if multilib_is_native_abi ; then
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
	fi
}

multilib_src_compile() {
	cmake-utils_src_compile
	local abi_build_dir=${BUILD_DIR}

	if multilib_is_native_abi ; then
		if use python ; then
			buildpybind() {
				cp "${abi_build_dir}"/{libRocketCore*,libRocketControls*} "${python_BUILD_DIR}-${EPYTHON}"/ || die
				BUILD_DIR="${python_BUILD_DIR}-${EPYTHON}" cmake-utils_src_make _rocketcontrols/fast _rocketcore/fast
			}
			einfo "compiling python binding"
			python_foreach_impl buildpybind
		fi
	fi
}

multilib_src_install() {
	cmake-utils_src_install

	if multilib_is_native_abi ; then
		if use python ; then
			instpybind() {
				python_domodule "${S}"/bin/rocket.py
				exeinto "$(python_get_sitedir)"
				doexe ${python_BUILD_DIR}-${EPYTHON}/_rocket{core,controls}.so
			}
			einfo "installing python binding"
			python_foreach_impl instpybind
		fi
	fi
}
