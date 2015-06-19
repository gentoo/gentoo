# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/mumps/mumps-4.10.0-r1.ebuild,v 1.1 2015/03/06 09:56:13 bircoph Exp $

EAPI=5

inherit eutils toolchain-funcs flag-o-matic versionator fortran-2 multilib

MYP=MUMPS_${PV}

DESCRIPTION="MUltifrontal Massively Parallel sparse direct matrix Solver"
HOMEPAGE="http://mumps.enseeiht.fr/"
SRC_URI="${HOMEPAGE}${MYP}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples metis mpi +scotch static-libs"

RDEPEND="
	virtual/blas
	metis? ( || ( sci-libs/metis <sci-libs/parmetis-4 )
		mpi? ( <sci-libs/parmetis-4 ) )
	scotch? ( <sci-libs/scotch-6[mpi=] )
	mpi? ( sci-libs/scalapack )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

static_to_shared() {
	local libstatic=${1}; shift
	local libname=$(basename ${libstatic%.a})
	local soname=${libname}$(get_libname $(get_version_component_range 1-2))
	local libdir=$(dirname ${libstatic})

	einfo "Making ${soname} from ${libstatic}"
	if [[ ${CHOST} == *-darwin* ]] ; then
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-dynamiclib -install_name "${EPREFIX}"/usr/lib/"${soname}" \
			-Wl,-all_load -Wl,${libstatic} \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
	else
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-shared -Wl,-soname=${soname} \
			-Wl,--whole-archive ${libstatic} -Wl,--no-whole-archive \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
		[[ $(get_version_component_count) -gt 1 ]] && \
			ln -s ${soname} ${libdir}/${libname}$(get_libname $(get_major_version))
		ln -s ${soname} ${libdir}/${libname}$(get_libname)
	fi
}

src_prepare() {
	sed -e "s:^\(CC\s*=\).*:\1$(tc-getCC):" \
		-e "s:^\(FC\s*=\).*:\1$(tc-getFC):" \
		-e "s:^\(FL\s*=\).*:\1$(tc-getFC):" \
		-e "s:^\(AR\s*=\).*:\1$(tc-getAR) cr :" \
		-e "s:^\(RANLIB\s*=\).*:\1$(tc-getRANLIB):" \
		-e "s:^\(LIBBLAS\s*=\).*:\1$($(tc-getPKG_CONFIG) --libs blas):" \
		-e "s:^\(INCPAR\s*=\).*:\1:" \
		-e 's:^\(LIBPAR\s*=\).*:\1$(SCALAP):' \
		-e "s:^\(OPTF\s*=\).*:\1${FFLAGS} -DALLOW_NON_INIT \$(PIC):" \
		-e "s:^\(OPTC\s*=\).*:\1${CFLAGS} \$(PIC):" \
		-e "s:^\(OPTL\s*=\).*:\1${LDFLAGS}:" \
		Make.inc/Makefile.inc.generic > Makefile.inc || die
	# fixed a missing copy of libseq to libdir
}

src_configure() {
	LIBADD="$($(tc-getPKG_CONFIG) --libs blas) -Llib -lpord"
	local ord="-Dpord"
	if use metis && use mpi; then
		sed -i \
			-e "s:#\s*\(LMETIS\s*=\).*:\1$($(tc-getPKG_CONFIG) --libs parmetis):" \
			-e "s:#\s*\(IMETIS\s*=\).*:\1$($(tc-getPKG_CONFIG) --cflags parmetis):" \
			Makefile.inc || die
		LIBADD="${LIBADD} $($(tc-getPKG_CONFIG) --libs parmetis)"
		ord="${ord} -Dparmetis"
	elif use metis; then
		sed -i \
			-e "s:#\s*\(LMETIS\s*=\).*:\1$($(tc-getPKG_CONFIG) --libs metis):" \
			-e "s:#\s*\(IMETIS\s*=\).*:\1$($(tc-getPKG_CONFIG) --cflags metis):" \
			Makefile.inc || die
		LIBADD="${LIBADD} $($(tc-getPKG_CONFIG) --libs metis)"
		ord="${ord} -Dmetis"
	fi
	if use scotch && use mpi; then
		sed -i \
			-e "s:#\s*\(LSCOTCH\s*=\).*:\1-lptesmumps -lptscotch -lptscotcherr:" \
			-e "s:#\s*\(ISCOTCH\s*=\).*:\1-I${EROOT}usr/include/scotch:" \
			Makefile.inc || die
		LIBADD="${LIBADD} -lptesmumps -lptscotch -lptscotcherr"
		ord="${ord} -Dptscotch"
	elif use scotch; then
		sed -i \
			-e "s:#\s*\(LSCOTCH\s*=\).*:\1-lesmumps -lscotch -lscotcherr:" \
			-e "s:#\s*\(ISCOTCH\s*=\).*:\1-I${EROOT}usr/include/scotch:" \
			Makefile.inc || die
		LIBADD="${LIBADD} -lesmumps -lscotch -lscotcherr"
		ord="${ord} -Dscotch"
	fi
	if use mpi; then
		sed -i \
			-e "s:^\(CC\s*=\).*:\1mpicc:" \
			-e "s:^\(FC\s*=\).*:\1mpif90:" \
			-e "s:^\(FL\s*=\).*:\1mpif90:" \
			-e "s:^\(SCALAP\s*=\).*:\1$($(tc-getPKG_CONFIG) --libs scalapack):" \
			Makefile.inc || die
		export LINK=mpif90
		LIBADD="${LIBADD} $($(tc-getPKG_CONFIG) --libs scalapack)"
	else
		sed -i \
			-e 's:-Llibseq:-L$(topdir)/libseq:' \
			-e 's:PAR):SEQ):g' \
			-e "s:^\(SCALAP\s*=\).*:\1:" \
			-e 's:^LIBSEQNEEDED =:LIBSEQNEEDED = libseqneeded:g' \
			Makefile.inc || die
		export LINK="$(tc-getFC)"
	fi
	sed -i -e "s:^\s*\(ORDERINGSF\s*=\).*:\1 ${ord}:" Makefile.inc || die
}

src_compile() {
	# Workaround #462602
	export FAKEROOTKEY=1

	# -j1 because of static archive race
	emake -j1 alllib PIC="-fPIC"
	if ! use mpi; then
		#$(tc-getAR) crs lib/libmumps_common.a libseq/*.o || die
		LIBADD+=" -Llibseq -lmpiseq"
		static_to_shared libseq/libmpiseq.a
	fi
	static_to_shared lib/libpord.a ${LIBADD}
	static_to_shared lib/libmumps_common.a ${LIBADD}

	local i
	for i in c d s z; do
		static_to_shared lib/lib${i}mumps.a -Llib -lmumps_common ${LIBADD}
	done
	if use static-libs; then
		emake clean
		emake -j1 alllib
	fi
}

src_test() {
	emake all
	local dotest
	if use mpi; then
		dotest="mpirun -np 2"
	else
		export LD_LIBRARY_PATH="${S}/libseq:${LD_LIBRARY_PATH}"
	fi
	cd examples
	${dotest} ./ssimpletest < input_simpletest_real || die
	${dotest} ./dsimpletest < input_simpletest_real || die
	${dotest} ./csimpletest < input_simpletest_cmplx || die
	${dotest} ./zsimpletest < input_simpletest_cmplx || die
	einfo "The solutions should be close to (1,2,3,4,5)"
	${dotest} ./c_example || die
	einfo "The solution should be close to (1,2)"
	make clean
}

src_install() {
	dolib.so lib/lib*$(get_libname)*
	use static-libs && dolib.a lib/lib*.a
	insinto /usr
	doins -r include
	if ! use mpi; then
		dolib.so libseq/lib*$(get_libname)*
		insinto /usr/include/mpiseq
		doins libseq/*.h
		use static-libs && dolib.a libseq/libmpiseq.a
	fi
	dodoc README ChangeLog VERSION
	use doc && dodoc doc/*.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
