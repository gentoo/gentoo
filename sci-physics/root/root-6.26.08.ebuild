# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ninja does not work due to fortran
CMAKE_MAKEFILE_GENERATOR=emake
FORTRAN_NEEDED="fortran"
PYTHON_COMPAT=( python3_{8..10} ) # python3_11 fails to compile

inherit cmake cuda elisp-common fortran-2 python-single-r1 toolchain-funcs

DESCRIPTION="C++ data analysis framework and interpreter from CERN"
HOMEPAGE="https://root.cern"

IUSE="+X aqua +asimage c++14 +c++17 cuda cudnn +davix debug emacs
	+examples fits fftw fortran +gdml graphviz +gsl http libcxx +minuit
	mpi mysql odbc +opengl oracle postgres pythia6 pythia8 +python
	qt5 R +roofit +root7 shadow sqlite +ssl +tbb test +tmva +unuran uring
	vc +xml xrootd"
RESTRICT="test"
PROPERTIES="test_network"

if [[ ${PV} =~ "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/root-project/root.git"
	if [[ ${PV} == "9999" ]]; then
		SLOT="0"
	else
		SLOT="$(ver_cut 1-2)/$(ver_cut 3)"
		EGIT_BRANCH="v$(ver_cut 1)-$(ver_cut 2)-00-patches"
	fi
else
	SLOT="$(ver_cut 1-2)/$(ver_cut 3)"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://root.cern/download/${PN}_v${PV}.source.tar.gz"
fi

LICENSE="LGPL-2.1 freedist MSttfEULA LGPL-3 libpng UoI-NCSA"

REQUIRED_USE="
	^^ ( c++14 c++17 )
	cuda? ( tmva )
	cudnn? ( cuda )
	!X? ( !asimage !opengl !qt5 )
	davix? ( ssl xml )
	python? ( ${PYTHON_REQUIRED_USE} )
	qt5? ( root7 )
	root7? ( || ( c++17 ) )
	tmva? ( gsl )
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
			dev-qt/qtgui:5
			dev-qt/qtwebengine:5[widgets]
		)
	)
	asimage? ( media-libs/libafterimage[gif,jpeg,png,tiff] )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-9.0 )
	cudnn? ( dev-libs/cudnn )
	davix? ( net-libs/davix )
	emacs? ( >=app-editors/emacs-23.1:* )
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
	oracle? ( dev-db/oracle-instantclient[sdk] )
	postgres? ( dev-db/postgresql:= )
	pythia6? ( sci-physics/pythia:6 )
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
	vc? ( dev-libs/vc:= )
	xml? ( dev-libs/libxml2:2= )
	xrootd? ( net-libs/xrootd:0= )
"

DEPEND="${CDEPEND}
	virtual/pkgconfig"

RDEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-6.12.06_cling-runtime-sysroot.patch
)

pkg_setup() {
	use fortran && fortran-2_pkg_setup
	use python && python-single-r1_pkg_setup

	elog "There are extra options on packages not available in Gentoo."
	elog "You can use the environment variable EXTRA_ECONF to enable"
	elog "these packages. For example, for Vdt you would set:"
	elog "EXTRA_ECONF=\"-Dbuiltin_vdt=ON -Dvdt=ON\""
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
#       Since ROOT installs many files into /etc (>100MB in total) that don't
#       really belong there, we install it into another directory to avoid
#       making /etc too big.

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_COMPILER="$(tc-getCC)"
		-DCMAKE_CXX_COMPILER="$(tc-getCXX)"
		-DLLVM_BUILD_TYPE=$(usex debug RelWithDebInfo Release)
		-DCMAKE_BUILD_TYPE=$(usex debug RelWithDebInfo Release)
		-DCMAKE_CUDA_HOST_COMPILER="$(tc-getCXX)"
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		-DCMAKE_CXX_STANDARD=$( (usev c++14 || usev c++17) | cut -c4-)
		-DPYTHON_EXECUTABLE="${EPREFIX}/usr/bin/${EPYTHON}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/${PN}/$(ver_cut 1-2)"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/${PN}/$(ver_cut 1-2)/share/man"
		-DCMAKE_INSTALL_LIBDIR="lib"
		-DDEFAULT_SYSROOT="${EPREFIX}"
		-DCLING_BUILD_PLUGINS=OFF
		-Dasserts=OFF
		-Ddev=OFF
		-Dexceptions=ON
		-Dfail-on-missing=ON
		-Dgnuinstall=OFF
		-Dshared=ON
		-Dsoversion=ON
		-Dbuiltin_llvm=ON
		-Dbuiltin_clang=ON
		-Dbuiltin_cling=ON
		-Dbuiltin_openui5=ON
		-Dbuiltin_afterimage=OFF
		-Dbuiltin_cfitsio=OFF
		-Dbuiltin_cppzmq=OFF
		-Dbuiltin_davix=OFF
		-Dbuiltin_fftw3=OFF
		-Dbuiltin_freetype=OFF
		-Dbuiltin_ftgl=OFF
		-Dbuiltin_gl2ps=OFF
		-Dbuiltin_glew=OFF
		-Dbuiltin_gsl=OFF
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
		-Dalien=OFF
		-Darrow=OFF
		-Dasimage=$(usex asimage)
		-Dccache=OFF # use ccache via portage
		-Dcefweb=OFF
		-Dclad=OFF
		-Dcocoa=$(usex aqua)
		-Dcuda=$(usex cuda)
		-Dcudnn=$(usex cudnn)
		-Dcxxmodules=OFF # requires clang, unstable
		-Ddataframe=ON
		-Ddavix=$(usex davix)
		-Ddcache=OFF
		-Ddistcc=OFF
		-Dfcgi=$(usex http)
		-Dfftw3=$(usex fftw)
		-Dfitsio=$(usex fits)
		-Dfortran=$(usex fortran)
		-Dgdml=$(usex gdml)
		-Dgfal=OFF
		-Dgminimal=OFF
		-Dgsl_shared=$(usex gsl)
		-Dgviz=$(usex graphviz)
		-Dhttp=$(usex http)
		-Dimt=$(usex tbb)
		-Dlibcxx=$(usex libcxx)
		-Dmathmore=$(usex gsl)
		-Dminimal=OFF
		-Dminuit2=$(usex minuit)
		-Dminuit=$(usex minuit)
		-Dmlp=$(usex tmva)
		-Dmonalisa=OFF
		-Dmpi=$(usex mpi)
		-Dmysql=$(usex mysql)
		-Dodbc=$(usex odbc)
		-Dopengl=$(usex opengl)
		-Doracle=$(usex oracle)
		-Dpgsql=$(usex postgres)
		-Dpyroot=$(usex python) # python was renamed to pyroot
		-Dpyroot_legacy=OFF
		-Dpythia6=$(usex pythia6)
		-Dpythia8=$(usex pythia8)
		-Dqt5web=$(usex qt5)
		-Dqt6web=OFF
		-Dr=$(usex R)
		-Droofit=$(usex roofit)
		-Droofit_multiprocess=OFF
		-Droot7=$(usex root7)
		-Drootbench=OFF
		-Droottest=OFF
		-Drpath=OFF
		-Druntime_cxxmodules=OFF
		-Dshadowpw=$(usex shadow)
		-Dspectrum=ON
		-Dsqlite=$(usex sqlite)
		-Dssl=$(usex ssl)
		-Dtcmalloc=OFF
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
		-Dx11=$(usex X)
		-Dxml=$(usex xml)
		-Dxrootd=$(usex xrootd)
		${EXTRA_ECONF}
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	ROOTSYS=${EPREFIX}/usr/lib/${PN}/$(ver_cut 1-2)

	if [[ ${PV} == "9999" ]]; then
		ROOTENV="9900${PN}-git"
	else
		ROOTENV="$((9999 - $(ver_cut 2)))${PN}-$(ver_cut 1-2)-git"
	fi

	cat > ${ROOTENV} <<- EOF || die
	MANPATH="${ROOTSYS}/share/man"
	PATH="${ROOTSYS}/bin"
	ROOTPATH="${ROOTSYS}/bin"
	LDPATH="${ROOTSYS}/lib"
	EOF

	if use python; then
		echo "PYTHONPATH=\"${ROOTSYS}/lib\"" >> ${ROOTENV} || die
	fi

	doenvd ${ROOTENV}

	if use emacs; then
		elisp-install ${PN}-$(ver_cut 1-2) "${BUILD_DIR}"/root-help.el
	fi

	pushd "${D}/${ROOTSYS}" > /dev/null

	rm -r emacs bin/*.{csh,sh,fish} || die

	if ! use examples; then
		rm -r tutorials || die
	fi

	# create versioned symlinks for binaries
	if [[ ! ${PV} == "9999" ]]; then
		cd bin;
		for exe in *; do
			dosym "${exe}" "/usr/lib/${PN}/$(ver_cut 1-2)/bin/${exe}-$(ver_cut 1-2)"
		done
	fi
}
