# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fortran-2 toolchain-funcs versionator flag-o-matic

MY_PN="${PN}_solve"
MY_PV="$(delete_version_separator 2)"
MY_P="${MY_PN}_${MY_PV}"

DESCRIPTION="Crystallography and NMR System"
HOMEPAGE="http://cns.csb.yale.edu/"
SRC_URI="
	${MY_P/p7}_all.tar.gz
	aria? ( aria2.3.1.tar.gz )"

SLOT="0"
LICENSE="cns"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="aria openmp"

RDEPEND="app-shells/tcsh"
DEPEND="${RDEPEND}"

FORTRAN_NEED_OPENMP=1

S="${WORKDIR}/${MY_P/p7}"

RESTRICT="fetch"

pkg_nofetch() {
	elog "Fill out the form at http://cns.csb.yale.edu/cns_request/"
	use aria && elog "and http://aria.pasteur.fr/"
	elog "and place these files:"
	elog ${A}
	elog "in ${DISTDIR}."
}

get_fcomp() {
	case $(tc-getFC) in
		*gfortran* )
			FCOMP="gfortran" ;;
		ifort )
			FCOMP="ifc" ;;
		* )
			FCOMP=$(tc-getFC) ;;
	esac
}

pkg_setup() {
	fortran-2_pkg_setup
	get_fcomp
}

get_bitness() {
	echo > "${T}"/test.c
	$(tc-getCC) ${CFLAGS} -c "${T}"/test.c -o "${T}"/test.o
	case $(file "${T}"/test.o) in
		*64-bit*|*ppc64*|*x86_64*) export _bitness="64";;
		*32-bit*|*ppc*|*i386*) export _bitness="32";;
		*) die "Failed to detect whether your arch is 64bits or 32bits, disable distcc if you're using it, please";;
	esac
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-gentoo.patch \
		"${FILESDIR}"/${PV}-delete.patch

	get_bitness

	if use aria; then
		pushd "${WORKDIR}"/aria* >& /dev/null
			# Update the cns sources in aria for version 1.2.1
			epatch "${FILESDIR}"/1.2.1-aria2.3.patch

			# Update the code with aria specific things
			cp -rf cns/src/* "${S}"/source/ || die
		popd >& /dev/null
	fi

	# the code uses Intel-compiler-specific directives
	if [[ $(tc-getFC) =~ gfortran ]]; then
		use openmp && \
			append-flags -fopenmp && append-ldflags -fopenmp
		COMP="gfortran"
		[[ ${_bitness} == 64 ]] && \
			append-fflags -fdefault-integer-8
	elif [[ $(tc-getFC) == if* ]]; then
		use openmp && \
			append-flags -openmp && append-ldflags -openmp
		COMP="ifort"
		[[ ${_bitness} == 64 ]] && append-fflags -i8
	fi

	[[ ${_bitness} == 64 ]] && \
		append-cflags "-DINTEGER='long long int'"

	# Set up location for the build directory
	# Uses obsolete `sort` syntax, so we set _POSIX2_VERSION
	cp "${FILESDIR}"/cns_solve_env_sh-${PV} "${T}"/cns_solve_env_sh || die
	sed \
		-e "s:_CNSsolve_location_:${S}:g" \
		-e "17 s:\(.*\):\1\nsetenv _POSIX2_VERSION 199209:g" \
		-i "${S}"/cns_solve_env || die
	sed \
		-e "s:_CNSsolve_location_:${S}:g" \
		-e "17 s:\(.*\):\1\nexport _POSIX2_VERSION; _POSIX2_VERSION=199209:g" \
		-e "s:setenv OMP_STACKSIZE 256m:export OMP_STACKSIZE=256m:g" \
		-e "s:^limit:^ulimit:g" \
		-i "${T}"/cns_solve_env_sh || die

	ebegin "Fixing shebangs..."
		find "${S}" -type f \
			-exec sed "s:/bin/csh:${EPREFIX}/bin/csh:g" -i '{}' + || die
		find . -name "Makefile*" \
			-exec \
				sed \
					-e "s:^SHELL=/bin/sh:SHELL=${EPREFIX}/bin/sh:g" \
					-e "s:/bin/ls:ls:g" \
					-e "s:/bin/rm:rm:g" \
					-i '{}' + || die
	eend
}

src_compile() {
	local GLOBALS
	local MALIGN

	# Set up the compiler to use
	ln -s Makefile.header instlib/machine/unsupported/g77-unix/Makefile.header.${FCOMP} || die

	# make install really means build, since it's expected to be used in-place
	# -j1 doesn't mean we do no respect MAKEOPTS!
	emake -j1 \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		F77=$(tc-getFC) \
		LD=$(tc-getFC) \
		CCFLAGS="${CFLAGS} -DCNS_ARCH_TYPE_\$(CNS_ARCH_TYPE) \$(EXT_CCFLAGS)" \
		CXXFLAGS="${CXXFLAGS} -DCNS_ARCH_TYPE_\$(CNS_ARCH_TYPE) \$(EXT_CCFLAGS)" \
		LDFLAGS="${LDFLAGS}" \
		F77OPT="${FCFLAGS} ${MALIGN}" \
		F77STD="${GLOBALS}" \
		OMPLIB="${OMPLIB}" \
		compiler="${COMP}" \
		install
}

src_test() {
	# We need to force on g77 manually, because we can't get aliases working
	# when we source in a -c
	einfo "Running tests ..."
	sh -c \
		"export CNS_G77=ON; source ${T}/cns_solve_env_sh; make run_tests" \
		|| die "tests failed"
	einfo "Displaying test results ..."
	cat "${S}"/*_g77/test/*.diff-test
}

src_install() {
	cat >> "${T}"/66cns <<- EOF
	CNS_SOLVE="${EPREFIX}/usr"
	CNS_ROOT="${EPREFIX}/usr"
	CNS_DATA="${EPREFIX}/usr/share/cns"
	CNS_DOC="${EPREFIX}/usr/share/doc/cns-1.3"
	CNS_LIB="${EPREFIX}/usr/share/cns/libraries"
	CNS_MODULE="${EPREFIX}/usr/share/cns/modules"
	CNS_TOPPAR="${EPREFIX}/usr/share/cns/libraries/toppar"
	CNS_CONFDB="${EPREFIX}/usr/share/cns/libraries/confdb"
	CNS_XTALLIB="${EPREFIX}/usr/share/cns/libraries/xtal"
	CNS_NMRLIB="${EPREFIX}/usr/share/cns/libraries/nmr"
	CNS_XRAYLIB="${EPREFIX}/usr/share/cns/libraries/xray"
	CNS_XTALMODULE="${EPREFIX}/usr/share/cns/modules/xtal"
	CNS_NMRMODULE="${EPREFIX}/usr/share/cns/modules/nmr"
	CNS_HELPLIB="${EPREFIX}/usr/share/cns/helplib"
	EOF

	doenvd "${T}"/66cns || die

	# Don't want to install this
	rm -f "${S}"/*linux*/utils/Makefile || die

	sed \
		-e "s:\$CNS_SOLVE/doc/:\$CNS_SOLVE/share/doc/${PF}/:g" \
		-i "${S}"/bin/cns_web || die

	newbin "${S}"/*linux*/bin/cns_solve* cns_solve

	# Can be run by either cns_solve or cns
	dosym cns_solve /usr/bin/cns

	dobin \
		"${S}"/*linux*/utils/* \
		"${S}"/bin/cns_{edit,header,import_cif,transfer,web}

	insinto /usr/share/cns
	doins -r "${S}"/libraries "${S}"/modules "${S}"/helplib "${S}"/bin/cns_info

	dohtml \
		-A iq,cgi,csh,cv,def,fm,gif,hkl,inp,jpeg,lib,link,list,mask,mtf,param,pdb,pdf,pl,ps,sc,sca,sdb,seq,tbl,top \
		-f all_cns_info_template,omac,def \
		-r doc/html/*
	# Conflits with app-text/dos2unix
	rm -f "${D}"/usr/bin/dos2unix || die
}

pkg_postinst() {
	if use openmp; then
		elog "Set OMP_NUM_THREADS to the number of threads you want."
		elog "If you get segfaults on large structures, set the GOMP_STACKSIZE"
		elog "variable if using gcc (16384 should be good)."
	fi
}
