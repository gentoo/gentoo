# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="A software that delivers parallel interactive visualizations"
HOMEPAGE="https://wci.llnl.gov/simulation/computer-codes/visit"
SRC_URI="http://portal.nersc.gov/svn/visit/trunk/releases/${PV}/${PN}${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cgns debug hdf5 mpi netcdf silo tcmalloc threads xdmf2"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	tcmalloc? ( dev-util/google-perftools )
	cgns? ( sci-libs/cgnslib )
	hdf5? ( sci-libs/hdf5 )
	netcdf? ( sci-libs/netcdf )
	silo? ( sci-libs/silo )
	=sci-libs/vtk-6.1.0*[imaging,mpi=,python,rendering,qt5,xdmf2?,${PYTHON_USEDEP}]
	dev-qt/qtx11extras:5
	sys-libs/zlib
	x11-libs/qwt:6[qt5]"
DEPEND="${RDEPEND}
	xdmf2? ( sci-libs/xdmf2 )
"

S="${WORKDIR}/${PN}${PV}/src"
PATCHES=(
	"${FILESDIR}/${P}-findpython.patch"
	"${FILESDIR}/${P}-findsilo.patch"
	"${FILESDIR}/${P}-findvtk.patch"
	"${FILESDIR}/${P}-vtklibs.patch"
	"${FILESDIR}/${P}-dont_symlink_visit_dir.patch"
	"${FILESDIR}/${P}-cmakelist.patch"
	"${FILESDIR}/${P}-qwt.patch"
)

src_prepare() {
	for p in ${PATCHES[@]} ; do
		epatch "${p}"
	done
	if use mpi ; then
		epatch "${FILESDIR}/${P}-vtkmpi.patch"
	fi

	sed -i 's/exec python $frontendlauncherpy $0 ${1+"$@"}/exec '${EPYTHON}' $frontendlauncherpy $0 ${1+"$@"}/g' "bin/frontendlauncher"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/opt/visit
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_DIR="${EPREFIX}/usr"
		-DVISIT_PYTHON_SKIP_INSTALL=true
		-DVISIT_VTK_SKIP_INSTALL=true
		-DQT_BIN="${EPREFIX}/usr/bin"
		-DVISIT_ZLIB_DIR="${EPREFIX}/usr"
		-DVISIT_HEADERS_SKIP_INSTALL=false
		-DVISIT_QWT_DIR="${EPREFIX}/usr"
		-DVISIT_QT5=true
		-DVISIT_QT_DIR=/usr/lib/qt5/
		$(cmake-utils_use threads VISIT_THREAD)
	)
	if use hdf5; then
		mycmakeargs+=( -DHDF5_DIR="${EPREFIX}/usr" )
	fi
	if use tcmalloc; then
		mycmakeargs+=( -DTCMALLOC_DIR="${EPREFIX}/usr" )
	fi
	if use cgns; then
		mycmakeargs+=( -DCGNS_DIR="${EPREFIX}/usr" )
	fi
	if use silo; then
		mycmakeargs+=( -DSILO_DIR="${EPREFIX}/usr" )
	fi
	if use netcdf; then
		mycmakeargs+=( -DNETCDF_DIR="${EPREFIX}/usr" )
	fi
	if use xdmf2; then
		mycmakeargs+=( -DOPT_VTK_MODS="vtklibxml2" -DVISIT_XDMF_DIR=/usr/ )
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	PACKAGES_DIR="${ROOT}opt/${PN}/${PV}/linux-$(arch)/lib/site-packages"
	cd "${ED}${PACKAGES_DIR}"
	for i in *; do
		dosym "${PACKAGES_DIR}/${i}" "$(python_get_sitedir)/$i"
	done

	cat > "${T}"/99visit <<- EOF
		PATH=${EPREFIX}/opt/${PN}/bin
		LDPATH=${EPREFIX}/opt/${PN}/${PV}/linux-$(arch)/lib/
	EOF
	doenvd "${T}"/99visit
}

pkg_postinst () {
	ewarn "Remember to run "
	ewarn "env-update && source /etc/profile"
	ewarn "if you want to use visit in already opened session"
}
