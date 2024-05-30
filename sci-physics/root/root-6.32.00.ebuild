# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ninja does not work due to fortran
CMAKE_MAKEFILE_GENERATOR=emake
FORTRAN_NEEDED="fortran"
PYTHON_COMPAT=( python3_{9..12} )

inherit cmake cuda flag-o-matic fortran-2 python-single-r1 toolchain-funcs

DESCRIPTION="C++ data analysis framework and interpreter from CERN"
HOMEPAGE="https://root.cern"
LICENSE="LGPL-2.1 freedist MSttfEULA LGPL-3 libpng UoI-NCSA"

IUSE="+X aqua +asimage cuda cudnn +davix debug +examples fits fftw fortran
	+gdml graphviz +gsl +http jupyter libcxx +minuit mpi mysql odbc +opengl
	postgres pythia8 +python qt5 qt6 R +roofit +root7 shadow sqlite +ssl
	+tbb test +tmva +unuran uring vc +xml xrootd"

if [[ ${PV} =~ "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/root-project/root.git"
	if [[ ${PV} == "9999" ]]; then
		SLOT="6/9999"
	else
		SLOT="6/$(ver_cut 1-3)"
		EGIT_BRANCH="v$(ver_cut 1)-$(ver_cut 2)-00-patches"
	fi
else
	SLOT="6/$(ver_cut 1-3)"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://root.cern/download/${PN}_v${PV}.source.tar.gz"
fi

RESTRICT="test"
PROPERTIES="test_network"

REQUIRED_USE="
	cuda? ( tmva )
	cudnn? ( cuda )
	!X? ( !asimage !opengl !qt5 !qt6 )
	davix? ( ssl xml )
	jupyter? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	qt5? ( root7 http )
	qt6? ( root7 http )
	roofit? ( minuit )
	tmva? ( gsl python )
	uring? ( root7 )
"

CDEPEND="
	app-arch/lz4
	app-arch/zstd
	app-arch/xz-utils
	fortran? ( dev-lang/cfortran )
	dev-cpp/nlohmann_json
	dev-libs/libpcre:3
	dev-libs/xxhash
	media-fonts/dejavu
	media-libs/freetype:2
	media-libs/libpng:0=
	virtual/libcrypt:=
	sys-libs/ncurses:=
	sys-libs/zlib
	X? (
		x11-libs/libX11:0
		x11-libs/libXext:0
		x11-libs/libXft:0
		x11-libs/libXpm:0
		opengl? (
			media-libs/ftgl:0=
			media-libs/glew:0=
			virtual/opengl
			virtual/glu
			x11-libs/gl2ps:0=
		)
		qt5? (
			dev-qt/qtcore:5
			dev-qt/qtwebengine:5[widgets]
		)
		qt6? (
			dev-qt/qtbase:6
			dev-qt/qtwebengine:6[widgets]
		)
	)
	cuda? ( >=dev-util/nvidia-cuda-toolkit-9.0 )
	cudnn? ( dev-libs/cudnn )
	davix? ( net-libs/davix )
	fftw? ( sci-libs/fftw:3.0= )
	fits? ( sci-libs/cfitsio:0= )
	graphviz? ( media-gfx/graphviz )
	gsl? ( sci-libs/gsl:= )
	http? ( dev-libs/fcgi:0= )
	libcxx? ( sys-libs/libcxx )
	unuran? ( sci-mathematics/unuran:0= )
	minuit? ( !sci-libs/minuit )
	mpi? ( virtual/mpi[fortran?] )
	mysql? ( dev-db/mysql-connector-c )
	odbc? (
		|| (
			dev-db/libiodbc
			dev-db/unixODBC
		)
	)
	postgres? ( dev-db/postgresql:= )
	pythia8? ( sci-physics/pythia:8 )
	python? ( ${PYTHON_DEPS} )
	R? ( dev-lang/R )
	shadow? ( sys-apps/shadow )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( dev-libs/openssl:0= )
	tbb? ( dev-cpp/tbb:= )
	tmva? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
	uring? ( sys-libs/liburing:= )
	vc? ( >=dev-libs/vc-1.4.4:= )
	xml? ( dev-libs/libxml2:2= )
	xrootd? ( net-libs/xrootd:0= )
"

DEPEND="${CDEPEND}
	virtual/pkgconfig"

RDEPEND="${CDEPEND}
	jupyter? (
		$(python_gen_cond_dep '
			dev-python/jupyter[${PYTHON_USEDEP}]
			dev-python/notebook[${PYTHON_USEDEP}]
			dev-python/metakernel[${PYTHON_USEDEP}]
		')
	)
"

BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/${PN}-6.12.06_cling-runtime-sysroot.patch
)

pkg_setup() {
	use fortran && fortran-2_pkg_setup
	python-single-r1_pkg_setup

	elog "There are extra options on packages not available in Gentoo."
	elog "You can use the environment variable MYCMAKEARGS to enable"
	elog "these packages. For example, for Vdt you would set:"
	elog "MYCMAKEARGS=\"-Dbuiltin_vdt=ON -Dvdt=ON\""
}

src_prepare() {
	use cuda && cuda_src_prepare

	cmake_src_prepare

	sed -i "/CLING_BUILD_PLUGINS/d" interpreter/CMakeLists.txt || die

	# CSS should use local images
	sed -i -e 's,http://.*/,,' etc/html/ROOT.css || die "html sed failed"

	eapply_user
}

# Note: ROOT uses bundled clang because it is patched and API-incompatible
#       with vanilla clang. The patches enable the C++ interpreter to work.

src_configure() {

	filter-lto # https://bugs.gentoo.org/879323

	local mycmakeargs=(
		-DCMAKE_C_COMPILER="$(tc-getCC)"
		-DCMAKE_CXX_COMPILER="$(tc-getCXX)"
		-DCMAKE_CUDA_HOST_COMPILER="$(tc-getCXX)"
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		# set build type flags to empty to avoid overriding CXXFLAGS
		-UCMAKE_C_FLAGS_RELEASE
		-UCMAKE_C_FLAGS_RELWITHDEBINFO
		-UCMAKE_CXX_FLAGS_RELEASE
		-UCMAKE_CXX_FLAGS_RELWITHDEBINFO
		# enable debug info in LLVM as well with USE=debug
		-DLLVM_BUILD_TYPE=$(usex debug RelWithDebInfo Release)
		-DPYTHON_EXECUTABLE="${EPREFIX}/usr/bin/${EPYTHON}"
		-DDEFAULT_SYSROOT="${EPREFIX}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_CMAKEDIR="$(get_libdir)/cmake/ROOT"
		-DCMAKE_INSTALL_DATADIR="share/root"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DCMAKE_INSTALL_FONTDIR="share/fonts/root"
		-DCMAKE_INSTALL_INCLUDEDIR="include/root"
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)/root"
		-DCMAKE_INSTALL_PYTHONDIR="${EPREFIX}/usr/lib/${EPYTHON}/site-packages"
		-DCMAKE_INSTALL_SRCDIR="${EPREFIX}/usr/src/debug/${CATEGORY}/${PF}"
		-DCMAKE_INSTALL_SYSCONFDIR="share/root"
		-DCMAKE_INSTALL_TUTDIR="share/root/tutorials"
		-DCLING_BUILD_PLUGINS=OFF
		-Dasan=OFF
		-Dasserts=$(usex debug)
		-Dccache=OFF # use ccache via portage
		-Dcoverage=OFF
		-Ddev=OFF
		-Ddistcc=OFF
		-Dfail-on-missing=ON
		-Dgnuinstall=ON
		-Dgminimal=OFF
		-Dshared=ON
		-Dsoversion=ON
		-Dbuiltin_llvm=ON
		-Dbuiltin_clang=ON
		-Dbuiltin_cling=ON
		-Dbuiltin_openui5=ON
		-Dbuiltin_cfitsio=OFF
		-Dbuiltin_cppzmq=OFF
		-Dbuiltin_davix=OFF
		-Dbuiltin_fftw3=OFF
		-Dbuiltin_freetype=OFF
		-Dbuiltin_ftgl=OFF
		-Dbuiltin_gl2ps=OFF
		-Dbuiltin_glew=OFF
		-Dbuiltin_gsl=OFF
		-Dbuiltin_gtest=OFF
		-Dbuiltin_lz4=OFF
		-Dbuiltin_lzma=OFF
		-Dbuiltin_nlohmannjson=OFF
		-Dbuiltin_openssl=OFF
		-Dbuiltin_pcre=OFF
		-Dbuiltin_tbb=OFF
		-Dbuiltin_unuran=OFF
		-Dbuiltin_vc=OFF
		-Dbuiltin_vdt=OFF
		-Dbuiltin_veccore=OFF
		-Dbuiltin_xrootd=OFF
		-Dbuiltin_xxhash=OFF
		-Dbuiltin_zeromq=OFF
		-Dbuiltin_zlib=OFF
		-Dbuiltin_zstd=OFF
		-Darrow=OFF
		-Dasimage=$(usex asimage)
		-Dcefweb=OFF
		-Dclad=OFF
		-Dcocoa=$(usex aqua)
		-Dcuda=$(usex cuda)
		-Dcudnn=$(usex cudnn)
		-Dcxxmodules=OFF # requires clang, unstable
		-Ddaos=OFF # not in gentoo
		-Ddataframe=ON
		-Ddavix=$(usex davix)
		-Ddcache=OFF
		-Dfcgi=$(usex http)
		-Dfftw3=$(usex fftw)
		-Dfitsio=$(usex fits)
		-Dfortran=$(usex fortran)
		-Dgdml=$(usex gdml)
		-Dgviz=$(usex graphviz)
		-Dhttp=$(usex http)
		-Dimt=$(usex tbb)
		-Dlibcxx=$(usex libcxx)
		-Dmathmore=$(usex gsl)
		-Dminuit=$(usex minuit)
		-Dmlp=$(usex tmva)
		-Dmpi=$(usex mpi)
		-Dmysql=$(usex mysql)
		-Dodbc=$(usex odbc)
		-Dopengl=$(usex opengl)
		-Dpgsql=$(usex postgres)
		-Dpyroot=$(usex python) # python was renamed to pyroot
		-Dpythia8=$(usex pythia8)
		-Dqt5web=$(usex qt5)
		-Dqt6web=$(usex qt6)
		-Dr=$(usex R)
		-Droofit=$(usex roofit)
		-Droofit_multiprocess=OFF
		-Droofit_hs3_ryml=OFF
		-Droot7=$(usex root7)
		-Drootbench=OFF
		-Droottest=OFF
		-Drpath=OFF
		-Druntime_cxxmodules=ON
		-Dshadowpw=$(usex shadow)
		-Dspectrum=ON
		-Dsqlite=$(usex sqlite)
		-Dssl=$(usex ssl)
		-Dtest_distrdf_dask=OFF
		-Dtest_distrdf_pyspark=OFF
		-Dtesting=$(usex test)
		-Dtmva=$(usex tmva)
		-Dtmva-cpu=$(usex tmva)
		-Dtmva-gpu=$(usex cuda)
		-Dtmva-pymva=$(usex tmva)
		-Dtmva-rmva=$(usex R)
		-Dtmva-sofie=OFF
		-Dunuran=$(usex unuran)
		-During=$(usex uring)
		-Dvc=$(usex vc)
		-Dvdt=OFF
		-Dveccore=OFF
		-Dvecgeom=OFF
		-Dwebgui=$(usex http)
		-Dx11=$(usex X)
		-Dxml=$(usex xml)
		-Dxrootd=$(usex xrootd)
	)

	# Needs to be here, otherwise gets overriden by cmake.eclass
	DCMAKE_BUILD_TYPE=$(usex debug RelWithDebInfo Release) cmake_src_configure
}

src_install() {
	cmake_src_install

	newenvd - 99root <<- EOF || die
	LDPATH="${EPREFIX}/usr/$(get_libdir)/root"
	EOF

	pushd "${ED}/usr" > /dev/null

	rm bin/*.{csh,sh,fish} || die

	if ! use examples; then
		rm -r share/root/tutorials || die
	fi

	popd

	use python && python_optimize
}
