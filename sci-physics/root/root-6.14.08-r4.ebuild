# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ninja does not work due to fortran
CMAKE_MAKEFILE_GENERATOR=emake
FORTRAN_NEEDED="fortran"
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit cmake-utils cuda eapi7-ver elisp-common eutils fortran-2 \
	prefix python-single-r1 toolchain-funcs

DESCRIPTION="C++ data analysis framework and interpreter from CERN"
HOMEPAGE="https://root.cern"
SRC_URI="https://root.cern/download/${PN}_v${PV}.source.tar.gz"

IUSE="+X aqua +asimage +c++11 c++14 c++17 cuda +davix debug emacs
	+examples fits fftw fortran +gdml graphviz +gsl http jemalloc
	kerberos ldap libcxx memstat +minuit mysql nosplash odbc +opengl
	oracle postgres prefix pythia6 pythia8 +python qt5 R +roofit root7
	shadow sqlite +ssl table +tbb test +threads +tiff +tmva +unuran vc
	xinetd +xml xrootd zeroconf"
RESTRICT="!test? ( test )"

SLOT="$(ver_cut 1-2)/$(ver_cut 3)"
LICENSE="LGPL-2.1 freedist MSttfEULA LGPL-3 libpng UoI-NCSA"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="
	^^ ( c++11 c++14 c++17 )
	cuda? ( tmva !c++17 )
	!X? ( !asimage !opengl !qt5 !tiff )
	davix? ( ssl xml )
	python? ( ${PYTHON_REQUIRED_USE} )
	qt5? ( root7 )
	root7? ( || ( c++14 c++17 ) )
	tmva? ( gsl )
"

CDEPEND="
	app-arch/lz4
	app-arch/xz-utils
	fortran? ( dev-lang/cfortran )
	dev-libs/libpcre:3
	dev-libs/xxhash
	media-fonts/dejavu
	media-libs/freetype:2
	media-libs/libpng:0=
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
	asimage? ( media-libs/libafterimage[gif,jpeg,png,tiff?] )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-9.0 )
	davix? ( net-libs/davix )
	emacs? ( >=app-editors/emacs-23.1:* )
	fftw? ( sci-libs/fftw:3.0= )
	fits? ( sci-libs/cfitsio:0= )
	graphviz? ( media-gfx/graphviz )
	gsl? ( sci-libs/gsl:= )
	http? ( dev-libs/fcgi:0= )
	jemalloc? ( dev-libs/jemalloc )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:0= )
	libcxx? ( sys-libs/libcxx )
	unuran? ( sci-mathematics/unuran:0= )
	minuit? ( !sci-libs/minuit )
	mysql? ( dev-db/mysql-connector-c )
	odbc? ( || ( dev-db/libiodbc dev-db/unixODBC ) )
	oracle? ( dev-db/oracle-instantclient-basic )
	postgres? ( dev-db/postgresql:= )
	pythia6? ( sci-physics/pythia:6 )
	pythia8? ( sci-physics/pythia:8 )
	python? ( ${PYTHON_DEPS} )
	R? ( dev-lang/R )
	shadow? ( virtual/shadow )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( dev-libs/openssl:0= )
	tbb? ( >=dev-cpp/tbb-2018 )
	tmva? ( dev-python/numpy[${PYTHON_USEDEP}] )
	vc? ( dev-libs/vc:= )
	xml? ( dev-libs/libxml2:2= )
	xrootd? ( net-libs/xrootd:0= )
"

DEPEND="${CDEPEND}
	virtual/pkgconfig"

RDEPEND="${CDEPEND}
	xinetd? ( sys-apps/xinetd )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.12.04-no-ocaml.patch
	"${FILESDIR}"/${PN}-6.12.06_cling-runtime-sysroot.patch
	"${FILESDIR}"/${PN}-6.14.06-oracle.patch
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
	cmake-utils_src_prepare

	sed -i "/CLING_BUILD_PLUGINS/d" interpreter/CMakeLists.txt || die

	# CSS should use local images
	sed -i -e 's,http://.*/,,' etc/html/ROOT.css || die "html sed failed"

	if use nosplash; then
		sed -i -e '/bool gNoLogo/s@false@true@' rootx/src/rootx.cxx
	fi

	hprefixify core/clingutils/CMakeLists.txt
}

# Note: ROOT uses bundled clang because it is patched and API-incompatible
#       with vanilla clang. The patches enable the C++ interpreter to work.
#       Since ROOT installs many files into /etc (>100MB in total) that don't
#       really belong there, we install it into another directory to avoid
#       making /etc too big.

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX%/}/usr/lib/${PN}/$(ver_cut 1-2)"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX%/}/usr/lib/${PN}/$(ver_cut 1-2)/share/man"
		-DCMAKE_INSTALL_LIBDIR="lib"
		-DDEFAULT_SYSROOT="${EPREFIX}"
		-DCLING_BUILD_PLUGINS=OFF
		-Dexplicitlink=ON
		-Dexceptions=ON
		-Dfail-on-missing=ON
		-Dgnuinstall=OFF
		-Dshared=ON
		-Dsoversion=ON
		-Dbuiltin_llvm=ON
		-Dbuiltin_clang=ON
		-Dbuiltin_afterimage=OFF
		-Dbuiltin_cfitsio=OFF
		-Dbuiltin_davix=OFF
		-Dbuiltin_fftw3=OFF
		-Dbuiltin_freetype=OFF
		-Dbuiltin_ftgl=OFF
		-Dbuiltin_gl2ps=OFF
		-Dbuiltin_glew=OFF
		-Dbuiltin_gsl=OFF
		-Dbuiltin_lz4=OFF
		-Dbuiltin_lzma=OFF
		-Dbuiltin_openssl=OFF
		-Dbuiltin_pcre=OFF
		-Dbuiltin_tbb=OFF
		-Dbuiltin_unuran=OFF
		-Dbuiltin_vc=OFF
		-Dbuiltin_vdt=OFF
		-Dbuiltin_veccore=OFF
		-Dbuiltin_xrootd=OFF
		-Dbuiltin_xxhash=OFF
		-Dbuiltin_zlib=OFF
		-Dx11=$(usex X)
		-Dxft=$(usex X)
		-Dafdsmgrd=OFF
		-Dafs=OFF # not implemented
		-Dalien=OFF
		-Dasimage=$(usex asimage)
		-Dastiff=$(usex tiff)
		-Dbonjour=$(usex zeroconf)
		-Dlibcxx=$(usex libcxx)
		-Dccache=OFF # use ccache via portage
		-Dcastor=OFF
		-Dchirp=OFF
		-Dclad=OFF
		-Dcling=ON # cling=OFF is broken
		-Dcocoa=$(usex aqua)
		-Dcuda=$(usex cuda)
		-Dcxx11=$(usex c++11)
		-Dcxx14=$(usex c++14)
		-Dcxx17=$(usex c++17)
		-Dcxxmodules=OFF # requires clang, unstable
		-Ddavix=$(usex davix)
		-Ddcache=OFF
		-Dfftw3=$(usex fftw)
		-Dfitsio=$(usex fits)
		-Dfortran=$(usex fortran)
		-Dftgl=$(usex opengl)
		-Dgdml=$(usex gdml)
		-Dgenvector=ON # genvector=OFF ignored
		-Dgeocad=OFF
		-Dgfal=OFF
		-Dgl2ps=$(usex opengl)
		-Dglite=OFF # not implemented
		-Dglobus=OFF
		-Dgminimal=OFF
		-Dgsl_shared=$(usex gsl)
		-Dgviz=$(usex graphviz)
		-Dhdfs=OFF
		-Dhttp=$(usex http)
		-Dimt=$(usex tbb)
		-Djemalloc=$(usex jemalloc)
		-Dkrb5=$(usex kerberos)
		-Dldap=$(usex ldap)
		-Dmathmore=$(usex gsl)
		-Dmemstat=$(usex memstat)
		-Dminimal=OFF
		-Dminuit2=$(usex minuit)
		-Dminuit=$(usex minuit)
		-Dmonalisa=OFF
		-Dmysql=$(usex mysql)
		-Dodbc=$(usex odbc)
		-Dopengl=$(usex opengl)
		-Doracle=$(usex oracle)
		-Dpch=ON # pch=OFF is broken
		-Dpgsql=$(usex postgres)
		-Dpythia6=$(usex pythia6)
		-Dpythia8=$(usex pythia8)
		-Dpython=$(usex python)
		-Dqt5web=$(usex qt5)
		-Dqtgsi=OFF
		-Dqt=OFF
		-Drfio=OFF
		-Droofit=$(usex roofit)
		-Droot7=$(usex root7)
		-Drootbench=OFF
		-Droottest=OFF
		-Drpath=OFF
		-Druby=OFF # deprecated and broken
		-Druntime_cxxmodules=OFF # does not work yet
		-Dr=$(usex R)
		-Dsapdb=OFF # not implemented
		-Dshadowpw=$(usex shadow)
		-Dsqlite=$(usex sqlite)
		-Dsrp=OFF # not implemented
		-Dssl=$(usex ssl)
		-Dtable=$(usex table)
		-Dtcmalloc=OFF
		-Dtesting=$(usex test)
		-Dthread=$(usex threads)
		-Dtmva=$(usex tmva)
		-Dtmva-cpu=$(usex tmva)
		-Dtmva-gpu=$(usex cuda)
		-Dunuran=$(usex unuran)
		-Dvc=$(usex vc)
		-Dvdt=OFF
		-Dveccore=OFF
		-Dxml=$(usex xml)
		-Dxrootd=$(usex xrootd)
		${EXTRA_ECONF}
	)

	CMAKE_BUILD_TYPE=$(usex debug Debug Release) \
	cmake-utils_src_configure
}

src_compile() {
	# needed for hsimple.root
	addwrite /dev/random
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	ROOTSYS=${EPREFIX%/}/usr/lib/${PN}/$(ver_cut 1-2)
	ROOTENV=$((9999 - $(ver_cut 2)))${PN}-$(ver_cut 1-2)

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

	rm -r test emacs bin/*.{csh,sh} || die

	if ! use examples; then
		rm -r tutorials || die
	fi

	# create versioned symlinks for binaries
	cd bin;
	for exe in *; do
		dosym "${exe}" "/usr/lib/${PN}/$(ver_cut 1-2)/bin/${exe}-$(ver_cut 1-2)"
	done
}
