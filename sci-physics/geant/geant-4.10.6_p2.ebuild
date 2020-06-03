# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_P=${PN}$(ver_cut 1-2).$(printf %02d $(ver_cut 3))

case ${PV} in
*_beta*)
	MY_P+=.b$(printf %02d $(ver_cut 5))
	DOCS="ReleaseNotes/Beta$(ver_cut 1-3)-*.txt"
	;;
*_p*)
	MY_P+=.p$(printf %02d $(ver_cut 5))
	DOCS="ReleaseNotes/Patch$(ver_cut 1-3)-*.txt"
	HTML_DOCS="ReleaseNotes/ReleaseNotes$(ver_cut 1-3).html"
	;;
*)
	HTML_DOCS="ReleaseNotes/ReleaseNotes$(ver_cut 1-3).html"
	;;
esac

DESCRIPTION="Toolkit for simulation of passage of particles through matter"
HOMEPAGE="https://geant4.web.cern.ch/"
SRC_URI="https://geant4-data.web.cern.ch/geant4-data/releases/${MY_P}.tar.gz"

LICENSE="geant4"
SLOT="4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+c++11 c++14 c++17 +data dawn doc examples freetype gdml geant3 hdf5
	inventor motif opengl qt5 raytracerx static-libs threads vrml"

REQUIRED_USE="^^ ( c++11 c++14 c++17 )"

RDEPEND="
	dev-libs/expat
	>=sci-physics/clhep-2.4.1.3:2=[threads?]
	data? ( ~sci-physics/geant-data-4.10.6_p1 )
	dawn? ( media-gfx/dawn )
	doc? ( ~app-doc/geant-docs-$(ver_cut 1-3) )
	gdml? ( dev-libs/xerces-c )
	hdf5? ( sci-libs/hdf5[threads?] )
	inventor? ( media-libs/SoXt )
	motif? ( x11-libs/motif:0 )
	opengl? ( virtual/opengl )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		opengl? ( dev-qt/qtopengl:5 )
	)
	raytracerx? (
		x11-libs/libX11
		x11-libs/libXmu
	)"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DATADIR="${EPREFIX}/usr/share/geant4"
		-DGEANT4_BUILD_CXXSTD=$((usev c++11 || usev c++14 || usev c++17) | cut -c4-)
		-DGEANT4_BUILD_MULTITHREADED=$(usex threads)
		-DGEANT4_BUILD_TLS_MODEL=$(usex threads global-dynamic initial-exec)
		-DGEANT4_INSTALL_DATA=OFF
		-DGEANT4_INSTALL_DATADIR="${EPREFIX}/usr/share/geant4/data"
		-DGEANT4_INSTALL_EXAMPLES=$(usex examples)
		-DGEANT4_USE_FREETYPE=$(usex freetype)
		-DGEANT4_USE_G3TOG4=$(usex geant3)
		-DGEANT4_USE_GDML=$(usex gdml)
		-DGEANT4_USE_HDF5=$(usex hdf5)
		-DGEANT4_USE_INVENTOR=$(usex inventor)
		-DGEANT4_USE_NETWORKDAWN=$(usex dawn)
		-DGEANT4_USE_NETWORKVRML=$(usex vrml)
		-DGEANT4_USE_OPENGL_X11=$(usex opengl)
		-DGEANT4_USE_QT=$(usex qt5)
		-DGEANT4_USE_RAYTRACER_X11=$(usex raytracerx)
		-DGEANT4_USE_SYSTEM_CLHEP=ON
		-DGEANT4_USE_SYSTEM_EXPAT=ON
		-DGEANT4_USE_SYSTEM_ZLIB=ON
		-DGEANT4_USE_WT=OFF
		-DGEANT4_USE_XM=$(usex motif)
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		${EXTRA_ECONF}
	)
	if use inventor; then
		mycmakeargs+=(
			-DINVENTOR_INCLUDE_DIR="$(coin-config --includedir)"
			-DINVENTOR_SOXT_INCLUDE_DIR="$(coin-config --includedir)"
		)
	fi
	cmake-utils_src_configure
}

src_install() {
	# adjust clhep linking flags for system clhep
	# binmake.gmk is only useful for legacy build systems
	sed -i -e 's/-lG4clhep/-lCLHEP/' config/binmake.gmk || die
	cmake-utils_src_install
	rm "${ED}"/usr/bin/*.{sh,csh} || die "failed to remove obsolete shell scripts"

	einstalldocs
}
