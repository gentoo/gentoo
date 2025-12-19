# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P=${PN}$(ver_cut 1)-v$(ver_cut 2-4)

case ${PV} in
*_beta*)
	DOCS="ReleaseNotes/Beta.$(ver_cut 2-3)-*.txt"
	;;
*)
	if [[ $(ver_cut 4) -gt 0 ]]; then
		DOCS="ReleaseNotes/Patch.$(ver_cut 2-3)-*.txt"
	fi
	HTML_DOCS="ReleaseNotes/ReleaseNotes.$(ver_cut 2-3).html"
	;;
esac

DESCRIPTION="Toolkit for simulation of passage of particles through matter"
HOMEPAGE="https://geant4.web.cern.ch/"
SRC_URI="https://geant4-data.web.cern.ch/geant4-data/releases/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="geant4"
SLOT="4/$(ver_cut 1-4)"

KEYWORDS="~amd64 ~x86"
IUSE="+data debug doc examples freetype gdml geant3 hdf5 inventor motif opengl
	qt6 raytracerx static-libs tbb threads trajectories vtk"

REQUIRED_USE="
	inventor? ( opengl )
	motif? ( opengl )
	qt6? ( opengl )
	raytracerx? ( opengl )
	tbb? ( threads )
	vtk? ( qt6 )
"

RDEPEND="
	dev-libs/expat
	>=sci-physics/clhep-2.4.7.1:2=[threads?,static-libs(+)?]
	data? ( ~sci-physics/geant-data-4.11.4 )
	doc? ( app-doc/geant-docs )
	gdml? ( dev-libs/xerces-c:= )
	hdf5? ( sci-libs/hdf5:=[threads?] )
	inventor? ( media-libs/SoXt )
	motif? ( x11-libs/motif:0 )
	opengl? (
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXmu
	)
	qt6? (
		dev-qt/qt3d:6
		dev-qt/qtbase:6[gui,opengl?,widgets]
	)
	vtk? ( sci-libs/vtk:=[qt6] )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.11.0.2-musl-avoid-execinfo.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DATADIR="${EPREFIX}/usr/share/geant4"
		-DGEANT4_BUILD_BUILTIN_BACKTRACE=$(usex debug)
		-DGEANT4_BUILD_MULTITHREADED=$(usex threads)
		-DGEANT4_BUILD_STORE_TRAJECTORY=$(usex trajectories)
		-DGEANT4_BUILD_TLS_MODEL=$(usex threads global-dynamic initial-exec)
		-DGEANT4_BUILD_VERBOSE_CODE=$(usex debug)
		-DGEANT4_INSTALL_DATA=OFF
		-DGEANT4_INSTALL_DATADIR="${EPREFIX}/usr/share/geant4/data"
		-DGEANT4_INSTALL_EXAMPLES=$(usex examples)
		-DGEANT4_INSTALL_PACKAGE_CACHE=OFF
		-DGEANT4_USE_FREETYPE=$(usex freetype)
		-DGEANT4_USE_G3TOG4=$(usex geant3)
		-DGEANT4_USE_GDML=$(usex gdml)
		-DGEANT4_USE_HDF5=$(usex hdf5)
		-DGEANT4_USE_INVENTOR=$(usex inventor)
		-DGEANT4_USE_OPENGL_X11=$(usex opengl)
		-DGEANT4_USE_QT=$(usex qt6)
		-DGEANT4_USE_QT_QT6=$(usex qt6)
		-DGEANT4_USE_RAYTRACER_X11=$(usex raytracerx)
		-DGEANT4_USE_SYSTEM_CLHEP=ON
		-DGEANT4_USE_SYSTEM_EXPAT=ON
		-DGEANT4_USE_SYSTEM_ZLIB=ON
		-DGEANT4_USE_TBB=$(usex tbb)
		-DGEANT4_USE_XM=$(usex motif)
		-DGEANT4_USE_VTK=$(usex vtk)
		-DBUILD_STATIC_LIBS=$(usex static-libs)
	)

	cmake_src_configure
}

src_install() {
	# adjust clhep linking flags for system clhep
	# binmake.gmk is only useful for legacy build systems
	sed -i -e 's/-lG4clhep/-lCLHEP/' config/binmake.gmk || die
	cmake_src_install
	rm "${ED}"/usr/bin/*.{sh,csh} || die "failed to remove obsolete shell scripts"
	einstalldocs
}
