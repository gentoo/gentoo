# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/root/root-6.02.05-r2.ebuild,v 1.5 2015/07/16 21:22:10 bircoph Exp $

EAPI=5

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="http://root.cern.ch/git/root.git"
else
	SRC_URI="ftp://root.cern.ch/${PN}/${PN}_v${PV}.source.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

PYTHON_COMPAT=( python2_7 )

inherit elisp-common eutils fdo-mime fortran-2 multilib python-single-r1 \
	toolchain-funcs user versionator

DESCRIPTION="C++ data analysis framework and interpreter from CERN"
HOMEPAGE="http://root.cern.ch/"
DOC_URI="ftp://root.cern.ch/${PN}/doc"

SLOT="0/$(get_version_component_range 1-3 ${PV})"
LICENSE="LGPL-2.1 freedist MSttfEULA LGPL-3 libpng UoI-NCSA"
IUSE="+X afs avahi doc emacs examples fits fftw gdml geocad
	graphviz http kerberos ldap +math +memstat mpi mysql odbc
	+opengl openmp oracle postgres prefix pythia6 pythia8
	python qt4 shadow sqlite ssl table +tiff xinetd xml xrootd"

# TODO: add support for: davix
# TODO: ROOT-6 supports x32 ABI, but half of its dependencies doesn't
# TODO: unbundle: cling, vdt

REQUIRED_USE="
	!X? ( !opengl !qt4 !tiff )
	mpi? ( math !openmp )
	openmp? ( math !mpi )
	python? ( ${PYTHON_REQUIRED_USE} )
"

CDEPEND="
	app-arch/xz-utils:0=
	>=dev-lang/cfortran-4.4-r2
	dev-libs/libpcre:3=
	media-fonts/dejavu
	media-libs/freetype:2=
	media-libs/libpng:0=
	>=sys-devel/clang-3.4:=
	sys-libs/zlib:0=
	X? (
		media-libs/ftgl:0=
		media-libs/glew:0=
		x11-libs/libX11:0=
		x11-libs/libXext:0=
		x11-libs/libXpm:0=
		|| (
			media-libs/libafterimage:0=[gif,jpeg,png,tiff?]
			>=x11-wm/afterstep-2.2.11:0=[gif,jpeg,png,tiff?]
		)
		opengl? ( virtual/opengl virtual/glu x11-libs/gl2ps:0= )
		qt4? (
			dev-qt/qtgui:4=
			dev-qt/qtopengl:4=
			dev-qt/qt3support:4=
			dev-qt/qtsvg:4=
			dev-qt/qtwebkit:4=
			dev-qt/qtxmlpatterns:4=
		)
		x11-libs/libXft:0=
	)
	afs? ( net-fs/openafs )
	avahi? ( net-dns/avahi:0= )
	emacs? ( virtual/emacs )
	fits? ( sci-libs/cfitsio:0= )
	fftw? ( sci-libs/fftw:3.0= )
	geocad? ( <sci-libs/opencascade-6.8.0:= )
	graphviz? ( media-gfx/graphviz:0= )
	http? ( dev-libs/fcgi:0= )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:0= )
	math? (
		sci-libs/gsl:0=
		sci-mathematics/unuran:0=
		mpi? ( virtual/mpi )
	)
	mysql? ( virtual/mysql )
	odbc? ( || ( dev-db/libiodbc:0= dev-db/unixODBC:0= ) )
	oracle? ( dev-db/oracle-instantclient-basic:0= )
	postgres? ( dev-db/postgresql:= )
	pythia6? ( sci-physics/pythia:6= )
	pythia8? ( >=sci-physics/pythia-8.1.80:8= )
	python? ( ${PYTHON_DEPS} )
	shadow? ( virtual/shadow )
	sqlite? ( dev-db/sqlite:3= )
	ssl? ( dev-libs/openssl:0= )
	xml? ( dev-libs/libxml2:2= )
	xrootd? ( >=net-libs/xrootd-3.3.5:0= )
"

# TODO: ruby is not yet ported to ROOT-6, reenable when (if?) ready
#		ruby? (
#			dev-lang/ruby:=
#			dev-ruby/rubygems:=
#		)

DEPEND="${CDEPEND}
	virtual/pkgconfig"

RDEPEND="${CDEPEND}
	xinetd? ( sys-apps/xinetd )"

PDEPEND="doc? ( ~app-doc/root-docs-${PV}[http=,math=] )"

# install stuff in ${P} and not ${PF} for easier tracking in root-docs
DOC_DIR="/usr/share/doc/${P}"

OC_UNSUPPORTED="6.8.0"

die_compiler() {
	eerror "You are using a $(tc-getCXX)-$5 without C++$1 capabilities"
	die "Need one of the following C++$1 capable compilers:\n"\
		"    >=sys-devel/gcc[cxx]-$2\n"\
		"    >=sys-devel/clang-$3\n"\
		"    >=dev-lang/icc-$4"
}

# check compiler to satisfy minimal versions
# $1 - std version
# $2 - g++
# $3 - clang++
# $4 - icc/icpc
check_compiler() {
	local ver
	case "$(tc-getCXX)" in
		*clang++*)
			ver="$(best_version sys-devel/clang | sed 's:sys-devel/clang-::')"
		;;
		*g++*)
			ver="$(gcc-version)"
		;;
		*icc*|*icpc*)
			ver="$(best_version dev-lang/icc | sed 's:dev-lang/icc-::')"
			eerror "ROOT-6 is known not to build with ICC."
			eerror "Please report any isuses upstream."
		;;
		*)
			ewarn "You are using an unsupported compiler."
			ewarn "Please report any issues upstream."
			return 0
		;;
	esac
	version_is_at_least "$3" "${ver}" || die_compiler "$1" "$2" "$3" "$4" "${ver}"
}

pkg_setup() {
	fortran-2_pkg_setup
	use python && python-single-r1_pkg_setup
	echo
	elog "There are extra options on packages not yet in Gentoo:"
	elog "Afdsmgrd, AliEn, castor, Chirp, dCache, gfal, Globus, gLite,"
	elog "HDFS, Monalisa, MaxDB/SapDB, SRP."
	elog "You can use the env variable EXTRA_ECONF variable for this."
	elog "For example, for SRP, you would set: "
	elog "EXTRA_ECONF=\"--enable-srp --with-srp-libdir=${EROOT%/}/usr/$(get_libdir)\""
	echo

	enewgroup rootd
	enewuser rootd -1 -1 /var/spool/rootd rootd

	if use math; then
		if use openmp; then
			if [[ "$(tc-getCXX)" == *g++* && "$(tc-getCXX)" != *clang++* ]] && ! tc-has-openmp; then
				ewarn "You are using a g++ without OpenMP capabilities"
				die "Need an OpenMP capable compiler"
			else
				export USE_OPENMP=1 USE_PARALLEL_MINUIT2=1
			fi
		elif use mpi; then
			export USE_MPI=1 USE_PARALLEL_MINUIT2=1
		fi
	fi

	# c++11 support is mandatory
	check_compiler "11" "4.8" "3.4" "13"

	# Active version of opencascade may be >= $OC_UNSUPPORTED,
	# so we need to eselect proper version (it must exist due to DEPEND requirement)
	if use geocad; then
		oc_current=$(eselect opencascade show)
		# Proceed only if active version is unsupported
		if version_is_at_least "${OC_UNSUPPORTED}" "${oc_current}"; then
			local -a vlist
			vlist=( $(version_sort $(eselect opencascade list | awk '/^ / { print $2 }')) )
			local i
			# search for higehr version < $OC_UNSUPPORTED
			# list is sorted acsending, so loop backwards
			for (( i=$(( ${#vlist[@]} -1 )); i>=0; i-- )); do
				version_is_at_least "${OC_UNSUPPORTED}" "${vlist[i]}" || break
			done
			[[ $i == "-1" ]] && die "No suitable opencascade eselect slot is available (<${OC_UNSUPPORTED})"

			einfo "Switching opencascade to supported slot: ${oc_current} -> ${vlist[i]}"
			eselect opencascade set ${vlist[i]} > /dev/null || die "eselect opencascade set ${vlist[i]} failed!"
		else
			# forget it, effectively disabling eselect cleanup
			unset oc_current
		fi
	fi
}

src_prepare() {
	# Second version of makepch is required in order to generate
	# PCH file appropriate for Gentoo include headers layout.
	# This can be done only at install stage, when files are placed
	# as appropriate. Premature modification of makepch.sh will
	# broke build process, however.
	#cp "etc/dictpch/makepch.sh" "etc/dictpch/makepch-gentoo.sh" || die

	epatch \
		"${FILESDIR}"/${PN}-5.28.00b-glibc212.patch \
		"${FILESDIR}"/${PN}-5.32.00-afs.patch \
		"${FILESDIR}"/${PN}-5.32.00-cfitsio.patch \
		"${FILESDIR}"/${PN}-5.32.00-chklib64.patch \
		"${FILESDIR}"/${PN}-5.34.13-desktop.patch \
		"${FILESDIR}"/${PN}-5.34.13-unuran.patch \
		"${FILESDIR}"/${PN}-6.00.01-dotfont.patch \
		"${FILESDIR}"/${PN}-6.00.01-geocad.patch \
		"${FILESDIR}"/${PN}-6.00.01-llvm.patch \
		"${FILESDIR}"/${PN}-6.00.01-nobyte-compile.patch \
		"${FILESDIR}"/${PN}-6.00.01-prop-flags.patch \
		"${FILESDIR}"/${PN}-6.02.05-xrootd4.patch
		#"${FILESDIR}"/${PN}-6.02.05-dictpch.patch \

	# make sure we use system libs and headers
	rm montecarlo/eg/inc/cfortran.h README/cfortran.doc || die
	rm -r graf2d/asimage/src/libAfterImage || die
	rm -r graf3d/ftgl/{inc,src} || die
	rm -r graf2d/freetype/src || die
	rm -r graf3d/glew/{inc,src} || die
	rm -r core/pcre/src || die
	rm -r math/unuran/src/unuran-*.tar.gz || die
	LANG=C LC_ALL=C find core/zip -type f -name "[a-z]*" -print0 | \
		xargs -0 rm || die
	rm -r core/lzma/src/*.tar.gz || die
	rm graf3d/gl/{inc,src}/gl2ps.* || die
	sed -i -e 's/^GLLIBS *:= .* $(OPENGLLIB)/& -lgl2ps/' \
		graf3d/gl/Module.mk || die

	# In Gentoo, libPythia6 is called libpythia6
	# iodbc is in /usr/include/iodbc
	# pg_config.h is checked instead of libpq-fe.h
	sed -i \
		-e 's:libPythia6:libpythia6:g' \
		-e 's:$ODBCINCDIR:$ODBCINCDIR /usr/include/iodbc:' \
		-e 's:libpq-fe.h:pg_config.h:' \
		configure || die "adjusting configure for Gentoo failed"

	# prefixify the configure script
	sed -i \
		-e 's:/usr:${EPREFIX}/usr:g' \
		configure || die "prefixify configure failed"

	# CSS should use local images
	sed -i -e 's,http://.*/,,' etc/html/ROOT.css || die "html sed failed"

	# QTDIR only used for qt3 in gentoo, and configure looks for it.
	unset QTDIR
}

# NB: ROOT uses bundled LLVM, because it is patched and API-incompatible with
# system LLVM.
# NB: As of 6.00.0.1 cmake is not ready as it can't fully replace configure,
# e.g. for afs and geocad.

src_configure() {
	local -a myconf
	# Some compilers need special care
	case "$(tc-getCXX)" in
		*clang++*)
			myconf=(
				--with-clang
				--with-f77="$(tc-getFC)"
			)
		;;
		*icc*|*icpc*)
			# For icc we need to provide architecture manually
			# and not to tamper with tc-get*
			use x86 && myconf=( linuxicc )
			use amd64 && myconf=( linuxx8664icc )
		;;
		*)	# gcc goes here too
			myconf=(
				--with-cc="$(tc-getCC)"
				--with-cxx="$(tc-getCXX)"
				--with-f77="$(tc-getFC)"
				--with-ld="$(tc-getCXX)"
			)
		;;
	esac

	# the configure script is not the standard autotools
	myconf+=(
		--prefix="${EPREFIX}/usr"
		--etcdir="${EPREFIX}/etc/root"
		--libdir="${EPREFIX}/usr/$(get_libdir)/${PN}"
		--docdir="${EPREFIX}${DOC_DIR}"
		--tutdir="${EPREFIX}${DOC_DIR}/examples/tutorials"
		--testdir="${EPREFIX}${DOC_DIR}/examples/tests"
		--disable-builtin-afterimage
		--disable-builtin-ftgl
		--disable-builtin-freetype
		--disable-builtin-glew
		--disable-builtin-lzma
		--disable-builtin-pcre
		--disable-builtin-zlib
		--disable-werror
		--enable-explicitlink
		--enable-shared
		--enable-soversion
		--fail-on-missing
		--nohowto
		--with-afs-shared=yes
		--with-sys-iconpath="${EPREFIX}/usr/share/pixmaps"
		$(use_enable X x11)
		$(use_enable X asimage)
		$(use_enable X xft)
		$(use_enable afs)
		$(use_enable avahi bonjour)
		$(use_enable fits fitsio)
		$(use_enable fftw fftw3)
		$(use_enable gdml)
		$(use_enable geocad)
		$(use_enable graphviz gviz)
		$(use_enable http)
		$(use_enable kerberos krb5)
		$(use_enable ldap)
		$(use_enable math genvector)
		$(use_enable math gsl-shared)
		$(use_enable math mathmore)
		$(use_enable math minuit2)
		$(use_enable math roofit)
		$(use_enable math tmva)
		$(use_enable math vc)
		$(use_enable math vdt)
		$(use_enable math unuran)
		$(use_enable memstat)
		$(use_enable mysql)
		$(usex mysql "--with-mysql-incdir=${EPREFIX}/usr/include/mysql" "")
		$(use_enable odbc)
		$(use_enable opengl)
		$(use_enable oracle)
		$(use_enable postgres pgsql)
		$(use_enable prefix rpath)
		$(use_enable pythia6)
		$(use_enable pythia8)
		$(use_enable python)
		$(use_enable qt4 qt)
		$(use_enable qt4 qtgsi)
		$(use_enable shadow shadowpw)
		$(use_enable sqlite)
		$(use_enable ssl)
		$(use_enable table)
		$(use_enable tiff astiff)
		$(use_enable xml)
		$(use_enable xrootd)
		${EXTRA_ECONF}
	)

	# usex can't be used here, because pg_config may be not
	# installed with USE="-postgres"
	use postgres && myconf+=( --with-pgsql-incdir=$(pg_config --includedir) )

	./configure ${myconf[@]} || die "configure failed"
}

src_compile() {
	emake \
		OPT="${CXXFLAGS}" \
		F77OPT="${FFLAGS}" \
		ROOTSYS="${S}" \
		LD_LIBRARY_PATH="${S}/lib"
	use emacs && elisp-compile build/misc/*.el
}

daemon_install() {
	local daemons="rootd proofd"
	dodir /var/spool/rootd
	fowners rootd:rootd /var/spool/rootd
	dodir /var/spool/rootd/{pub,tmp}
	fperms 1777 /var/spool/rootd/{pub,tmp}

	local i
	for i in ${daemons}; do
		newinitd "${FILESDIR}"/${i}.initd ${i}
		newconfd "${FILESDIR}"/${i}.confd ${i}
	done
	if use xinetd; then
		insinto /etc/xinetd
		doins "${S}"/etc/daemons/{rootd,proofd}.xinetd
	fi
}

desktop_install() {
	cd "${S}"
	echo "Icon=root-system-bin" >> etc/root.desktop
	domenu etc/root.desktop
	doicon build/package/debian/root-system-bin.png

	insinto /usr/share/icons/hicolor/48x48/mimetypes
	doins build/package/debian/application-x-root.png

	insinto /usr/share/icons/hicolor/48x48/apps
	doicon build/package/debian/root-system-bin.xpm
}

cleanup_install() {
	# Cleanup of files either already distributed or unused on Gentoo
	pushd "${ED}" > /dev/null
	rm usr/share/root/fonts/LICENSE || die
	rm etc/root/proof/*.sample || die
	rm -r etc/root/daemons || die
	# these should be in PATH
	mv etc/root/proof/utils/pq2/pq2* usr/bin/ || die
	rm ${DOC_DIR#/}/{INSTALL,LICENSE} || die
	use examples || rm -r ${DOC_DIR#/}/examples || die

	# clean hardcoded sandbox paths
	#rm etc/root/dictpch/allCppflags.txt.tmp || die
	#sed -i "s|${S}/||" etc/root/cling/llvm/Config/llvm-config.h || die
	# regenerate pch for Gentoo headers layout
	#rm "etc/root/allDict.cxx.pch" || die
	#sed -i 's|etc/dictpch|etc/root/dictpch|' etc/root/dictpch/allLinkDefs.h || die
	#sed -i 's|etc/cling|etc/root/cling|' etc/root/dictpch/allHeaders.h || die
	#sed -i "s|ROOTDIR_TEMPLATE|${ED}|" etc/root/dictpch/makepch-gentoo.sh || die
	#etc/root/dictpch/makepch-gentoo.sh etc/root/allDict.cxx.pch || die "PCH generation failed"
}

src_install() {
	ROOTSYS="${S}" emake DESTDIR="${D}" install
	dodoc README.md

	echo "LDPATH=${EPREFIX%/}/usr/$(get_libdir)/root" > 99root
	use pythia8 && echo "PYTHIA8=${EPREFIX%/}/usr" >> 99root

	if use python; then
		echo "PYTHONPATH=${EPREFIX%/}/usr/$(get_libdir)/root" >> 99root
		python_optimize "${D}/usr/$(get_libdir)/root"
	fi
	use emacs && elisp-install ${PN} build/misc/*.{el,elc}
	if use examples; then
		# these should really be taken care of by the root make install
		insinto ${DOC_DIR}/examples/tutorials/tmva
		doins -r tmva/test
	fi
	doenvd 99root

	# The build system installs Emacs support unconditionally in the wrong
	# directory. Remove it and call elisp-install in case of USE=emacs.
	rm -r "${ED}"/usr/share/emacs || die

	daemon_install
	desktop_install
	cleanup_install

	# do not copress files used by ROOT's CLI (.credit, .demo, .license)
	docompress -x "${DOC_DIR}"/{CREDITS,examples/tutorials}
	# needed for .license command to work
	dosym "${ED}"usr/portage/licenses/LGPL-2.1 "${DOC_DIR}/LICENSE"
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	# restort opencascade eselect slot
	if use geocad && [[ -n ${oc_current} ]]; then
		einfo "Switching to user set slot: $(eselect opencascade show) -> ${oc_current}"
		eselect opencascade set ${oc_current} > /dev/null || eerror "eselect opencascade set ${vlist[i]} failed!"
		unset oc_current
	fi
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
