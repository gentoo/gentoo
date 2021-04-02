# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake check-reqs java-pkg-opt-2

DESCRIPTION="Development platform for CAD/CAE, 3D surface/solid modeling and data exchange"
HOMEPAGE="https://github.com/tpaviot/oce"
SRC_URI="https://github.com/tpaviot/oce/archive/OCE-${PV}.tar.gz"

LICENSE="|| ( Open-CASCADE-LGPL-2.1-Exception-1.0 LGPL-2.1 )"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="examples freeimage gl2ps +openmp tbb vtk"
REQUIRED_USE="?? ( openmp tbb )"

DEPEND="
	dev-lang/tcl:0=
	dev-lang/tk:0=
	dev-tcltk/itcl
	dev-tcltk/itk
	dev-tcltk/tix
	media-libs/ftgl
	media-libs/freetype
	virtual/glu
	virtual/opengl
	x11-libs/libXmu
	freeimage? ( media-libs/freeimage )
	gl2ps? ( x11-libs/gl2ps )
	tbb? ( dev-cpp/tbb )
	vtk? ( =sci-libs/vtk-8*[boost,imaging,qt5,python,rendering,views,xdmf2] )"
RDEPEND="${DEPEND}"

CHECKREQS_MEMORY="256M"
CHECKREQS_DISK_BUILD="3584M"

PATCHES=( "${FILESDIR}"/"${P}-test-fix.patch" )

S="${WORKDIR}/oce-OCE-${PV}"

pkg_setup() {
	check-reqs_pkg_setup
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	# From BUILD.Unix.md
	local mycmakeargs=(
		-DOCE_INSTALL_PREFIX="/usr"
		-DOCE_ENABLE_DEB_FLAG=off
		-DOCE_COPY_HEADERS_BUILD=yes
		-DOCE_DRAW=yes
		-DOCE_WITH_FREEIMAGE=$(usex freeimage)
		-DOCE_WITH_GL2PS=$(usex gl2ps)
		-DOCE_WITH_VTK=$(usex vtk)
	)
	# Mutual exclusion of tbb and openmp flags is guaranteed by REQUIRED_USE.
	use tbb && mycmakeargs+=(
		-DOCE_MULTITHREAD_LIBRARY="TBB"
	)
	use openmp && mycmakeargs+=(
		-DOCE_MULTITHREAD_LIBRARY="OPENMP"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# If user asked for samples let's copy them to the docs folder
	if use examples ; then
		dodoc -r samples
	fi
}
