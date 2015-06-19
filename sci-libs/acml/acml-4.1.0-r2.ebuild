# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/acml/acml-4.1.0-r2.ebuild,v 1.2 2015/03/31 20:09:31 ulm Exp $

EAPI=5

inherit eutils fortran-2 multilib toolchain-funcs versionator

MY_P=${PN}-$(replace_all_version_separators -)

DESCRIPTION="AMD Core Math Library for x86 and amd64 CPUs"
HOMEPAGE="http://developer.amd.com/acml.jsp"
SRC_URI="
	amd64? (
		ifc? ( ${MY_P}-ifort-64bit.tgz
			int64? ( ${MY_P}-ifort-64bit-int64.tgz ) )
		gfortran? (	 ${MY_P}-gfortran-64bit.tgz
			int64? ( ${MY_P}-gfortran-64bit-int64.tgz ) )
		!ifc? (
			!gfortran? ( ${MY_P}-gfortran-64bit.tgz
				int64? ( ${MY_P}-gfortran-64bit-int64.tgz ) ) ) )
	x86? (
		ifc? ( ${MY_P}-ifort-32bit.tgz )
		gfortran? ( ${MY_P}-gfortran-32bit.tgz )
		!ifc? ( !gfortran? ( ${MY_P}-gfortran-32bit.tgz ) ) )"

SLOT="0"
LICENSE="ACML"
KEYWORDS="-* ~amd64 ~x86"
IUSE="doc examples gfortran ifc int64 openmp test"

RESTRICT="strip fetch"

CDEPEND="
	ifc? ( dev-lang/ifc )
	gfortran? ( =sys-devel/gcc-4.2* )
	!gfortran? ( !ifc? ( =sys-devel/gcc-4.2* ) )"

DEPEND="
	app-eselect/eselect-blas
	app-eselect/eselect-lapack
	test? (	${CDEPEND} )"

RDEPEND="${CDEPEND}
	app-eselect/eselect-blas
	app-eselect/eselect-lapack
	doc? ( app-doc/blas-docs app-doc/lapack-docs )"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download the ACML from:"
	einfo "${HOMEPAGE}"
	einfo "and place it in ${DISTDIR}."
	einfo "The previous versions could be found at"
	einfo "http://developer.amd.com/acmlarchive.jsp"
	einfo "SRC=${A} $SRC_URI"
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
	if use test; then
		# work around incomplete fortran eclass
		if use gfortran &&
			[[ $(tc-getFC) =~ gfortran ]] &&
			[[ $(gcc-version) != 4.2 ]]
		then
			eerror "You need gfortran-4.2 to test acml"
			eerror "Please use gcc-config to switch gcc version 4.2"
			die "gfortran check failed"
		fi
	fi
	if use openmp; then
		tc-has-openmp || die "Please ensure your compiler has openmp support"
		FORTRAN_NEED_OPENMP=1
	fi
	fortran-2_pkg_setup
	get_fcomp
	# construct default profile dprof from default ddir
	local ddir=gfortran
	use ifc && ddir=ifort
	use x86 && ddir=${ddir}32 || ddir=${ddir}64
	use openmp && ddir=${ddir}_mp
	use int64 && ddir=${ddir}_int64
	ACML_DEFAULT_DIR=${ddir}
}

src_unpack() {
	unpack ${A}
	unpack ./contents-acml-*.tgz
	use openmp || rm -rf *_mp*
}

src_test() {
	# only testing with current chosen compiler
	for fdir in ${ACML_DEFAULT_DIR/_mp}*; do
		einfo "Testing acml in ${fdir}"
		for d in . acml_mv; do
			cd "${S}"/${fdir}/examples/${d}
			emake \
				ACMLDIR="${S}"/${fdir} \
				F77=$(tc-getFC) \
				CC="$(tc-getCC)" \
				CPLUSPLUS="$(tc-getCXX)"
			emake clean
		done
	done
}

make_acml_profile_name() {
	local fort=${1%%[[:digit:]]*}
	local opt=${1#*[0-9][0-9]}
	echo ${PN}-${fort}${opt/mp/openmp} | tr '_' '-'
}

src_install() {
	# respect acml default install dir (and FHS)
	local instdir=/opt/${PN}${PV}
	dodir ${instdir}

	for lib in */lib; do
		local fdir=${lib%/*}
		# install acml
		use examples || rm -rf "${S}"/${fdir}/examples
		cp -pPR "${S}"/${fdir} "${D}"${instdir} || die "copy ${fdir} failed"

		# install profiles
		local prof=$(make_acml_profile_name ${fdir})
		local acmldir=${instdir}/${fdir}
		local acmllibs="-lacml"
		local libname=${acmldir}/lib/libacml
		local extlibs
		local extflags
		[[ ${fdir} =~ int64 ]] && extflags="${extflags} -fdefault-integer-8"
		[[ ${fdir} =~ gfortran ]] && extlibs="${extlibs} -lgfortran"
		if [[ ${fdir} =~ _mp ]]; then
			[[ ${fdir} =~ ifort ]] && extlibs="${extlibs} -lguide"
			extlibs="${extlibs} -lpthread"
			extflags="${extflags} -fopenmp"
			acmllibs="-lacml_mp"
			libname=${libname}_mp
		fi
		use amd64 && acmllibs="${acmllibs} -lacml_mv"
		for x in blas lapack; do
			# pkgconfig files
			sed -e "s:@LIBDIR@:$(get_libdir):" \
				-e "s:@PV@:${PV}:" \
				-e "s:@ACMLDIR@:${acmldir}:g" \
				-e "s:@ACMLLIBS@:${acmllibs}:g" \
				-e "s:@EXTLIBS@:${extlibs}:g" \
				-e "s:@EXTFLAGS@:${extflags}:g" \
				"${FILESDIR}"/${x}.pc.in > ${x}.pc \
				|| die "sed ${x}.pc failed"
			insinto ${acmldir}/lib
			doins ${x}.pc

			# eselect files
			cat > eselect.${prof}.${x} <<-EOF
				${libname}.so /usr/@LIBDIR@/lib${x}.so.0
				${libname}.so /usr/@LIBDIR@/lib${x}.so
				${libname}.a /usr/@LIBDIR@/lib${x}.a
				${acmldir}/lib/${x}.pc /usr/@LIBDIR@/pkgconfig/${x}.pc
			EOF
			eselect ${x} add $(get_libdir) eselect.${prof}.${x} ${prof}
		done
	done

	echo "LDPATH=${instdir}/${ACML_DEFAULT_DIR}/lib" > 35acml
	doenvd "${S}"/35acml
	use doc || rm -rf "${S}"/Doc/acml.pdf "${S}"/Doc/html
	cp -pPR "${S}"/Doc "${D}"${instdir} || die "copy doc failed"
}

pkg_postinst() {
	local dprof="$(make_acml_profile_name ${ACML_DEFAULT_DIR})"
	for x in blas lapack; do
		local cprof=$(eselect ${x} show | cut -d' ' -f2)
		if [[ ${cprof} == ${dprof} || -z ${cprof} ]]; then
		# work around eselect bug #189942
			local configfile="${ROOT}"/etc/env.d/${x}/$(get_libdir)/config
			[[ -e ${configfile} ]] && rm -f ${configfile}
			eselect ${x} set ${dprof}
			elog "${x} has been eselected to ${dprof}"
		else
			elog "Current eselected ${x} implementation is ${cprof}"
			elog "To use you have one of ${PN}, issue (as root):"
			elog "\t eselect ${x} set <profile>"
		fi
	done
}
