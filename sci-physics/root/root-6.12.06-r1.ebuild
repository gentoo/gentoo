# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_BUILD_TYPE=Release
# ninja does not work due to fortran
CMAKE_MAKEFILE_GENERATOR=emake
FORTRAN_NEEDED="fortran"
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils elisp-common eutils fortran-2 gnome2-utils prefix \
	python-single-r1 toolchain-funcs user versionator xdg-utils

DESCRIPTION="C++ data analysis framework and interpreter from CERN"
HOMEPAGE="https://root.cern"
SRC_URI="https://root.cern/download/${PN}_v${PV}.source.tar.gz"

IUSE="+X avahi aqua +asimage +davix emacs +examples fits fftw fortran +gdml
	graphviz +gsl http jemalloc kerberos ldap libcxx +math memstat +minuit
	mysql odbc +opengl oracle postgres prefix pythia6 pythia8 +python qt4
	R +roofit root7 shadow sqlite ssl table +tbb test +threads +tiff +tmva
	+unuran vc xinetd +xml xrootd"

MY_PV="$(get_version_component_range 1-2 ${PV})"
MY_P="${PN}/$(get_version_component_range 1-2 ${PV})"
MY_PREFIX=opt/${MY_P}

SLOT="${MY_PV}/$(get_version_component_range 3 ${PV})"
LICENSE="LGPL-2.1 freedist MSttfEULA LGPL-3 libpng UoI-NCSA"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="
	!X? ( !asimage !opengl !qt4 !tiff )
	python? ( ${PYTHON_REQUIRED_USE} )
	tmva? ( math gsl )
	davix? ( ssl )
"

CDEPEND="
	app-arch/lz4
	app-arch/xz-utils
	fortran? ( dev-lang/cfortran )
	dev-libs/libpcre:3=
	dev-libs/xxhash
	media-fonts/dejavu
	media-libs/freetype:2=
	media-libs/libpng:0=
	sys-libs/ncurses:=
	sys-libs/zlib:0=
	X? (
		x11-libs/libX11:0=
		x11-libs/libXext:0=
		x11-libs/libXft:0=
		x11-libs/libXpm:0=
		opengl? (
			media-libs/ftgl:0=
			media-libs/glew:0=
			virtual/opengl
			virtual/glu
			x11-libs/gl2ps:0=
		)
		qt4? (
			dev-qt/qtcore:4=
			dev-qt/qtgui:4=
			opengl? ( dev-qt/qtopengl:4= )
		)
	)
	asimage? ( || (
		media-libs/libafterimage[gif,jpeg,png,tiff?]
		>=x11-wm/afterstep-2.2.11[gif,jpeg,png,tiff?]
	) )
	avahi? ( net-dns/avahi[mdnsresponder-compat] )
	davix? ( net-libs/davix )
	fftw? ( sci-libs/fftw:3.0= )
	fits? ( sci-libs/cfitsio:0= )
	graphviz? ( media-gfx/graphviz:0= )
	gsl? ( sci-libs/gsl )
	http? ( dev-libs/fcgi:0= )
	jemalloc? ( dev-libs/jemalloc )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:0= )
	libcxx? ( sys-libs/libcxx )
	unuran? ( sci-mathematics/unuran:0= )
	minuit? ( !sci-libs/minuit )
	mysql? ( virtual/mysql )
	odbc? ( || ( dev-db/libiodbc dev-db/unixODBC ) )
	oracle? ( dev-db/oracle-instantclient-basic )
	postgres? ( dev-db/postgresql:= )
	pythia6? ( sci-physics/pythia:6= )
	pythia8? ( sci-physics/pythia:8= )
	python? ( ${PYTHON_DEPS} )
	R? ( dev-lang/R )
	shadow? ( virtual/shadow )
	sqlite? ( dev-db/sqlite:3= )
	ssl? ( dev-libs/openssl:0= )
	tbb? ( dev-cpp/tbb )
	vc? ( dev-libs/vc )
	xml? ( dev-libs/libxml2:2= )
	xrootd? ( net-libs/xrootd:0= )
"

DEPEND="${CDEPEND}
	virtual/pkgconfig"

RDEPEND="${CDEPEND}
	xinetd? ( sys-apps/xinetd )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.11.02-hsimple.patch
	"${FILESDIR}"/${PN}-6.12.04-no-ocaml.patch
	"${FILESDIR}"/${PN}-6.12.04-no-opengl.patch
	"${FILESDIR}"/${PN}-6.12.04-z3.patch
)

pkg_setup() {
	use fortran && fortran-2_pkg_setup
	use python && python-single-r1_pkg_setup

	echo
	elog "There are extra options on packages not yet in Gentoo:"
	elog "Afdsmgrd, AliEn, castor, Chirp, dCache, gfal, Globus, gLite,"
	elog "HDFS, Monalisa, MaxDB/SapDB, SRP, VecCore."
	elog "You can use the env variable EXTRA_ECONF variable for this."
	elog "For example, for Chirp, you would set: "
	elog "EXTRA_ECONF=\"-Dchirp=ON\""
	echo

	enewgroup rootd
	enewuser rootd -1 -1 /var/spool/rootd rootd
}

src_prepare() {
	cmake-utils_src_prepare

	hprefixify build/CMakeLists.txt core/clingutils/CMakeLists.txt
	eapply "${FILESDIR}"/${PN}-6.12.06_cling-runtime-sysroot.patch

	# CSS should use local images
	sed -i -e 's,http://.*/,,' etc/html/ROOT.css || die "html sed failed"
}

# Note: ROOT uses bundled LLVM, because it is patched and API-incompatible with system LLVM.
# Note: ROOT will install many compiler headers and other files into suboptimal places, so
#       we install it into /opt due to QA concerns over the files installed into <prefix>/etc

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/${MY_PREFIX}"
		-DDEFAULT_SYSROOT="${EPREFIX}"
		-Dexplicitlink=ON
		-Dexceptions=ON
		-Dfail-on-missing=ON
		-Dshared=ON
		-Dsoversion=ON
		-Dbuiltin_llvm=ON
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
		-Dafs=OFF # option not implemented
		-Dalien=OFF
		-Dasimage=$(usex asimage)
		-Dastiff=$(usex tiff)
		-Dbonjour=$(usex avahi)
		-Dccache=OFF # use ccache via portage
		-Dcastor=OFF
		-Dchirp=OFF
		# -Dcling=ON # cling=OFF is broken
		-Dcocoa=$(usex aqua)
		-Dcxx14=$(usex root7)
		# -Dcxxmodules=OFF # use clang C++ modules
		-Ddavix=$(usex davix)
		-Ddcache=OFF # not in Gentoo
		-Dfftw3=$(usex fftw)
		-Dfitsio=$(usex fits)
		-Dfortran=$(usex fortran)
		-Dftgl=$(usex opengl)
		-Dgdml=$(usex gdml)
		-Dgl2ps=$(usex opengl)
		-Dgeocad=OFF # default OFF
		-Dgenvector=$(usex math) # default ON
		-Dgfal=OFF # not in Gentoo
		-Dglite=OFF # option not implemented
		-Dglobus=OFF
		-Dgminimal=OFF
		-Dgnuinstall=OFF
		-Dgsl_shared=$(usex gsl)
		-Dgviz=$(usex graphviz)
		-Dhdfs=OFF # deps not in Gentoo
		-Dhttp=$(usex http)
		-Dimt=$(usex tbb)
		-Djemalloc=$(usex jemalloc)
		-Dkrb5=$(usex kerberos)
		-Dldap=$(usex ldap)
		-Dlibcxx=$(usex libcxx)
		-Dmathmore=$(usex math)
		-Dmemstat=$(usex memstat)
		#-Dminimal=$(usex minimal) # default OFF
		-Dminuit=$(usex minuit)
		-Dminuit2=$(usex minuit)
		-Dmonalisa=OFF # not in Gentoo
		-Dmysql=$(usex mysql)
		-Dodbc=$(usex odbc)
		-Dopengl=$(usex opengl)
		-Doracle=$(usex oracle)
		# -Dpch=$(usex pch) # needs cling
		-Dpgsql=$(usex postgres)
		-Dpythia6=$(usex pythia6)
		-Dpythia8=$(usex pythia8)
		-Dpython=$(usex python)
		-Dqt=$(usex qt4)
		-Dqtgsi=$(usex qt4)
		-Dr=$(usex R) # requires Rcpp and RInside
		-Drfio=OFF
		-Droofit=$(usex roofit)
		-Droot7=$(usex root7) # requires C++14
		-Droottest=OFF # requires network
		-Drpath=$(usex prefix)
		-Druby=OFF # unmantained upstream
		# -Druntime_cxxmodules=OFF # use clang C++ modules
		-Dsapdb=OFF # option not implemented
		-Dshadowpw=$(usex shadow)
		-Dsqlite=$(usex sqlite)
		-Dsrp=OFF # option not implemented
		-Dssl=$(usex ssl)
		-Dtable=$(usex table)
		-Dtbb=$(usex tbb)
		-Dtcmalloc=OFF
		-Dtesting=$(usex test)
		-Dthread=$(usex threads)
		-Dtmva=$(usex tmva)
		-Dunuran=$(usex unuran)
		-Dvc=$(usex vc)
		-Dvdt=OFF # not in Gentoo
		# -Dveccore=OFF # not in Gentoo
		-Dxml=$(usex xml) # default ON
		-Dxrootd=$(usex xrootd) # default ON
		${EXTRA_ECONF}
	)

	cmake-utils_src_configure
}

daemon_install() {
	local daemons="rootd proofd"
	dodir /var/spool/rootd
	fowners rootd:rootd /var/spool/rootd
	dodir /var/spool/rootd/{pub,tmp}
	fperms 1777 /var/spool/rootd/{pub,tmp}
	keepdir /var/spool/rootd/{pub,tmp}

	local i
	for i in ${daemons}; do
		newinitd "${FILESDIR}"/${i}.initd ${i}
		newconfd "${FILESDIR}"/${i}.confd ${i}
	done
	if use xinetd; then
		insinto /etc/xinetd
		doins "${BUILD_DIR}"/etc/daemons/{rootd,proofd}.xinetd
	fi
}

desktop_install() {
	pushd "${S}" > /dev/null
	echo "Icon=root-system-bin" >> etc/root.desktop
	domenu etc/root.desktop
	doicon build/package/debian/root-system-bin.png

	insinto /usr/share/icons/hicolor/48x48/mimetypes
	doins build/package/debian/application-x-root.png

	insinto /usr/share/icons/hicolor/48x48/apps
	doicon build/package/debian/root-system-bin.xpm
}

src_install() {
	cmake-utils_src_install

	# root fails without this symlink, because it looks only into lib
	[[ -d lib ]] || dosym $(get_libdir) /${MY_PREFIX}/lib

	use emacs && elisp-install ${PN} "${BUILD_DIR}"/root-help.el

	echo "PATH=${EPREFIX}/${MY_PREFIX}/bin" > 99root || die
	echo "ROOTPATH=${EPREFIX}/${MY_PREFIX}/bin" >> 99root || die
	echo "LDPATH=${EPREFIX}/${MY_PREFIX}/$(get_libdir)" >> 99root || die

	if use pythia8; then
		echo "PYTHIA8=${EPREFIX}/usr" >> 99root || die
	fi

	if use python; then
		echo "PYTHONPATH=${EPREFIX}/${MY_PREFIX}/lib" >> 99root
		python_optimize "${ED}/${MY_PREFIX}/lib"
	fi

	doenvd 99root

	daemon_install
	desktop_install

	pushd "${ED}" > /dev/null
	rm -r ${MY_PREFIX}/{config,emacs,etc/vmc,fonts} || die

	if ! use examples; then
		rm -r ${MY_PREFIX}/{test,tutorials} || die
	fi

	if use tmva; then
		rm -r ${MY_PREFIX}/tmva || die
	fi

	# do not copress files used by ROOT's CLI (.credit, .demo, .license)
	docompress -x "${MY_PREFIX}/README/CREDITS"
	use examples && docompress -x "${MY_PREFIX}/tutorials"
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
