# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit check-reqs eutils fortran-2 multilib toolchain-funcs

PID=1232
PB=${PN}
P_ARCHIVE=l_${PN}_p_${PV}

DESCRIPTION="Intel(R) Math Kernel Library: linear algebra, fft, math functions"
HOMEPAGE="https://software.intel.com/en-us/mkl"
SRC_URI="http://registrationcenter-download.intel.com/irc_nas/${PID}/${P_ARCHIVE}.tgz"

SLOT="0"
LICENSE="Intel-SDP"
KEYWORDS="-* amd64 ~ia64 x86"
IUSE="doc fftw fortran95 int64 mpi"

RESTRICT="strip mirror"

DEPEND="
	app-eselect/eselect-blas
	app-eselect/eselect-cblas
	app-eselect/eselect-lapack"
RDEPEND="${DEPEND}
	doc? ( app-doc/blas-docs app-doc/lapack-docs )
	mpi? ( virtual/mpi )"

MKL_DIR=/opt/intel/${PN}/${PV}
INTEL_LIC_DIR=/opt/intel/licenses

CHECKREQS_DISK_BUILD=3500M

QA_PREBUILT="opt/intel/${PN}/${PV}/*"

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
	check-reqs_pkg_setup
	fortran-2_pkg_setup
	# Check the license
	if [[ -z ${MKL_LICENSE} ]]; then
		MKL_LICENSE="$(grep -ls MKern ${ROOT}${INTEL_LIC_DIR}/* | tail -n 1)"
		MKL_LICENSE=${MKL_LICENSE/${ROOT}/}
	fi
	if  [[ -z ${MKL_LICENSE} ]]; then
		eerror "Did not find any valid mkl license."
		eerror "Register at ${HOMEPAGE} to receive a license"
		eerror "and place it in ${INTEL_LIC_DIR} or run:"
		eerror "export MKL_LICENSE=/my/license/file emerge mkl"
		die "license setup failed"
	fi

	# Check if we have enough free diskspace to install
	CHECKREQS_DISK_BUILD="1100M"
	check-reqs_pkg_setup

	# Check and setup fortran
	if use fortran95; then
		# blas95 and lapack95 don't compile with gfortran < 4.2
		[[ $(tc-getFC) =~ (gfortran|g77) ]] && [[ $(gcc-major-version)$(gcc-minor-version) -lt 42 ]] &&
		die "blas95 and lapack95 don't compile with gfortran < 4.2"
	fi
	MKL_FC="gnu"
	[[ $(tc-getFC) =~ if ]] && MKL_FC="intel"

	# build profiles according to what compiler is installed
	MKL_CC="gnu"
	[[ $(tc-getCC) == icc ]] && MKL_CC="intel"

	if has_version sys-cluster/mpich; then
		MKL_MPI=mpich
	elif has_version sys-cluster/mpich2; then
		MKL_MPI=mpich2
	elif has_version sys-cluster/openmpi; then
		MKL_MPI=openmpi
	else
		MKL_MPI=intelmpi
	fi
	get_fcomp
}

src_unpack () {
	default
	cd "${WORKDIR}/${P_ARCHIVE}"/install || die

	cp ${MKL_LICENSE} "${WORKDIR}"/ || die
	MKL_LIC="$(basename ${MKL_LICENSE})"

	# binary blob extractor installs rpm leftovers in /opt/intel
	addwrite /opt/intel
	# undocumented features: INSTALLMODE_mkl=NONRPM

	# We need to install mkl non-interactively.
	# If things change between versions, first do it interactively:
	# tar xf l_*; ./install.sh --duplicate mkl.ini;
	# The file will be instman/mkl.ini
	# Then check it and modify the ebuild-created one below
	# --norpm is required to be able to install 10.x
	cat > mkl.ini <<-EOF
		[MKL]
		EULA_ACCEPT_REJECT=ACCEPT
		FLEXLM_LICENSE_LOCATION=${WORKDIR}/${MKL_LIC}
		INSTALLMODE_mkl=NONRPM
		INSTALL_DESTINATION=${S}
	EOF
	einfo "Extracting ..."
	./install \
		--silent ./mkl.ini \
		--installpath "${S}" \
		--log log.txt &> /dev/null

	if [[ -z $(find "${S}" -name libmkl.so) ]]; then
		eerror "Could not find extracted files"
		eerror "See ${PWD}/log.txt to see why"
		die "extracting failed"
	fi
}

src_prepare() {
	# remove left over
	rm -f /opt/intel/.*mkl*.log /opt/intel/intel_sdp_products.db || die

	# remove unused stuff and set up intel names
	rm -rf "${WORKDIR}"/l_* || die

	# allow openmpi to work
	epatch "${FILESDIR}"/${PN}-10.0.2.018-openmpi.patch
	# make scalapack tests work for gfortran
	#epatch "${FILESDIR}"/${PN}-10.0.2.018-tests.patch
	case ${ARCH} in
		x86)	MKL_ARCH=32
				MKL_KERN=ia32
				rm -rf lib*/{em64t,64} || die
				;;

		amd64)	MKL_ARCH=em64t
				MKL_KERN=em64t
				rm -rf lib*/{32,64} || die
				;;

		ia64)	MKL_ARCH=64
				MKL_KERN=ipf
				rm -rf lib*/{32,em64t} || die
				;;
	esac
	MKL_LIBDIR=${MKL_DIR}/lib/${MKL_ARCH}
	# fix env scripts
	sed -i \
		-e "s:${S}:${MKL_DIR}:g" \
		tools/environment/*sh || die "sed support file failed"
}

src_compile() {
	cd "${S}"/interfaces || die
	if use fortran95; then
		einfo "Compiling fortan95 static lib wrappers"
		local myconf="lib${MKL_ARCH}"
		[[ $(tc-getFC) =~ gfortran ]] && \
			myconf="${myconf} FC=gfortran"
		if use int64; then
			myconf="${myconf} interface=ilp64"
			[[ $(tc-getFC) =~ gfortran ]] && \
				myconf="${myconf} FOPTS=-fdefault-integer-8"
		fi
		local x
		for x in blas95 lapack95; do
			pushd ${x} > /dev/null || die
			emake ${myconf}
			popd > /dev/null || die
		done
	fi

	if use fftw; then
		local fftwdirs="fftw2xc fftw2xf fftw3xc fftw3xf"
		local myconf="lib${MKL_ARCH} compiler=${MKL_CC}"
		if use mpi; then
			fftwdirs="${fftwdirs} fftw2x_cdft"
			myconf="${myconf} mpi=${MKL_MPI}"
		fi
		einfo "Compiling fftw static lib wrappers"
		local x
		for x in ${fftwdirs}; do
			pushd ${x} > /dev/null || die
			emake ${myconf}
			popd > /dev/null || die
		done
	fi
}

src_test() {
	cd "${S}"/tests
	local myconf
	local testdirs="blas cblas"
	use int64 && myconf="${myconf} interface=ilp64"
	# buggy with g77 and gfortran
	#if use mpi; then
	#	testdirs="${testdirs} scalapack"
	#	myconf="${myconf} mpi=${MKL_MPI}"
	#fi
	for x in ${testdirs}; do
		pushd ${x}
		einfo "Testing ${x}"
		emake \
			compiler=${MKL_FC} \
			${myconf} \
			so${MKL_ARCH} \
			|| die "emake ${x} failed"
		popd
	done
}

mkl_make_generic_profile() {
	cd "${S}" || die
	# produce eselect files
	# don't make them in FILESDIR, it changes every major version
	cat  > eselect.blas <<-EOF
		${MKL_LIBDIR}/libmkl_${MKL_KERN}.a /usr/@LIBDIR@/libblas.a
		${MKL_LIBDIR}/libmkl.so /usr/@LIBDIR@/libblas.so
		${MKL_LIBDIR}/libmkl.so /usr/@LIBDIR@/libblas.so.0
	EOF
	cat  > eselect.cblas <<-EOF
		${MKL_LIBDIR}/libmkl_${MKL_KERN}.a /usr/@LIBDIR@/libcblas.a
		${MKL_LIBDIR}/libmkl.so /usr/@LIBDIR@/libcblas.so
		${MKL_LIBDIR}/libmkl.so /usr/@LIBDIR@/libcblas.so.0
		${MKL_DIR}/include/mkl_cblas.h /usr/include/cblas.h
	EOF
	cat > eselect.lapack <<-EOF
		${MKL_LIBDIR}/libmkl_lapack.a /usr/@LIBDIR@/liblapack.a
		${MKL_LIBDIR}/libmkl_lapack.so /usr/@LIBDIR@/liblapack.so
		${MKL_LIBDIR}/libmkl_lapack.so /usr/@LIBDIR@/liblapack.so.0
	EOF
}

# usage: mkl_add_profile <profile> <interface_lib> <thread_lib> <rtl_lib>
mkl_add_profile() {
	cd "${S}" || die
	local prof=${1}
	local x
	for x in blas cblas lapack; do
		cat > ${x}-${prof}.pc <<-EOF
			prefix=${MKL_DIR}
			libdir=${MKL_LIBDIR}
			includedir=\${prefix}/include
			Name: ${x}
			Description: Intel(R) Math Kernel Library implementation of ${x}
			Version: ${PV}
			URL: ${HOMEPAGE}
		EOF
	done
	cat >> blas-${prof}.pc <<-EOF
		Libs: -Wl,--no-as-needed -L\${libdir} ${2} ${3} -lmkl_core ${4} -lpthread
	EOF
	cat >> cblas-${prof}.pc <<-EOF
		Requires: blas
		Libs: -Wl,--no-as-needed -L\${libdir} ${2} ${3} -lmkl_core ${4} -lpthread
		Cflags: -I\${includedir}
	EOF
	cat >> lapack-${prof}.pc <<-EOF
		Requires: blas
		Libs: -Wl,--no-as-needed -L\${libdir} ${2} ${3} -lmkl_core -lmkl_lapack ${4} -lpthread
	EOF
	insinto ${MKL_LIBDIR}
	for x in blas cblas lapack; do
		doins ${x}-${prof}.pc
		cp eselect.${x} eselect.${x}.${prof} || die
		echo "${MKL_LIBDIR}/${x}-${prof}.pc /usr/@LIBDIR@/pkgconfig/${x}.pc" \
			>> eselect.${x}.${prof}
		eselect ${x} add $(get_libdir) eselect.${x}.${prof} ${prof}
	done
}

mkl_make_profiles() {
	local clib="gf"
	has_version 'dev-lang/ifc' && clib+=" intel"
	local slib="-lmkl_sequential"
	local rlib="-liomp5"
	local pbase=${PN}
	local c
	for c in ${clib}; do
		local ilib="-lmkl_${c}_lp64"
		use x86 && ilib="-lmkl_${c}"
		local tlib="-lmkl_${c/gf/gnu}_thread"
		local comp="${c/gf/gfortran}"
		comp="${comp/intel/ifort}"
		mkl_add_profile ${pbase}-${comp} ${ilib} ${slib}
		mkl_add_profile ${pbase}-${comp}-threads ${ilib} ${tlib} ${rlib}
		if use int64; then
			ilib="-lmkl_${c}_ilp64"
			mkl_add_profile ${pbase}-${comp}-int64 ${ilib} ${slib}
			mkl_add_profile ${pbase}-${comp}-threads-int64 ${ilib} ${tlib} ${rlib}
		fi
	done
}

src_install() {
	dodir ${MKL_DIR}

	# install license
	if  [[ ! -f ${INTEL_LIC_DIR}/${MKL_LIC} ]]; then
		insinto ${INTEL_LIC_DIR}
		doins "${WORKDIR}"/${MKL_LIC} || die "install license failed"
	fi

	# install main stuff: cp faster than doins
	einfo "Installing files..."
	local cpdirs="benchmarks doc examples include interfaces lib man tests"
	local doinsdirs="tools"
	cp -pPR ${cpdirs} "${D}"${MKL_DIR} \
		|| die "installing mkl failed"
	insinto ${MKL_DIR}
	doins -r ${doinsdirs} || die "doins ${doinsdirs} failed"
	dosym mkl_cblas.h ${MKL_DIR}/include/cblas.h

	# install blas/lapack profiles
	mkl_make_generic_profile
	mkl_make_profiles

	# install env variables
	cat > 35mkl <<-EOF
		MKLROOT=${MKL_DIR}
		LDPATH=${MKL_LIBDIR}
		MANPATH=${MKL_DIR}/man
	EOF
	doenvd 35mkl
}

pkg_postinst() {
	# if blas profile is mkl, set lapack and cblas profiles as mkl
	local blas_prof=$(eselect blas show | cut -d' ' -f2)
	local def_prof="mkl-gfortran-threads"
	has_version 'dev-lang/ifc' && def_prof="mkl-ifort-threads"
	use int64 && def_prof="${def_prof}-int64"
	for x in blas cblas lapack; do
		local cur_prof=$(eselect ${x} show | cut -d' ' -f2)
		if [[ -z ${cur_prof} ||	${cur_prof} == ${def_prof} ]]; then
			# work around eselect bug #189942
			local configfile="${ROOT}"/etc/env.d/${x}/$(get_libdir)/config
			[[ -e ${configfile} ]] && rm -f ${configfile}
			eselect ${x} set ${def_prof}
			elog "${x} has been eselected to ${def_prof}"
		else
			elog "Current eselected ${x} is ${current_lib}"
			elog "To use one of mkl profiles, issue (as root):"
			elog "\t eselect ${x} set <profile>"
		fi
		if [[ ${blas_prof} == mkl* && ${cur_prof} != ${blas_prof} ]]; then
			eselect blas set ${def_prof}
			elog "${x} is now set to ${def_prof} for consistency"
		fi
	done
	if [[ $(gcc-major-version)$(gcc-minor-version) -lt 42 ]]; then
		elog "Multi-threading OpenMP for GNU compilers only available"
		elog "with gcc >= 4.2. Make sure you have a compatible version"
		elog "and select it with gcc-config before selecting gnu profiles"
	fi
}
