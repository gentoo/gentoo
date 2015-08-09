# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils multilib python-single-r1

DESCRIPTION="eXtensible Data Model and Format"
HOMEPAGE="http://xdmf.org/index.php/Main_Page"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="VTK"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="doc python test"

RDEPEND="
	sci-libs/hdf5:=
	dev-libs/libxml2:2
	python? ( ${PYTHON_DEPS} )
	"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	python? ( dev-lang/swig:0 )
"

PATCHES=( "${FILESDIR}"/${P}-module.patch )

pkg_setup() {
	use python && python-single-r1_pkg_setup && python_export
}

src_prepare() {
	if use python; then
		local _site=$(python_get_sitedir)
		sed \
			-e "/DESTINATION/s:python:${_site##${EPREFIX}/usr/$(get_libdir)/}:g" \
			-i CMakeLists.txt || die
	fi

	sed \
		-e "/DESTINATION/s:lib:$(get_libdir):g" \
		-e "/INSTALL/s:lib:$(get_libdir):g" \
		-i CMakeLists.txt core/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use doc XDMF_BUILD_DOCUMENTATION)
		$(cmake-utils_use_build test TESTING)
		$(cmake-utils_use python XDMF_WRAP_PYTHON)
#		$(cmake-utils_use java XDMF_WRAP_JAVA)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dosym XdmfConfig.cmake /usr/share/cmake/Modules/${PN}Config.cmake
}
