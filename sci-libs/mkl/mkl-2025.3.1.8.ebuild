# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

PN_VER=$(ver_cut 1-2)
MY_PV=$(ver_cut 1-3)-$(ver_cut 4)
DESCRIPTION="Intel Math Kernel Library"
HOMEPAGE="https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl.html"
# Upstream packages are a mess -- and most of them are literally empty.
SRC_URI="
	https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-core-${PN_VER}-${MY_PV}_amd64.deb
	https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-core-devel-${PN_VER}-${MY_PV}_amd64.deb
	https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-classic-include-${PN_VER}-${MY_PV}_amd64.deb
"
S="${WORKDIR}"

LICENSE="ISSL"
SLOT="0"
KEYWORDS="~amd64"
IUSE="eselect-ldso examples gnu-openmp llvm-openmp static-libs tbb"
RESTRICT="strip"

RDEPEND="
	eselect-ldso? (
		app-eselect/eselect-blas
		app-eselect/eselect-lapack
	)
	gnu-openmp? ( sys-devel/gcc:*[openmp] )
	llvm-openmp? ( llvm-runtimes/openmp )
	tbb? ( dev-cpp/tbb )
"
# bug #801460
BDEPEND="
	app-arch/xz-utils[extra-filters(+)]
	eselect-ldso? (
		app-eselect/eselect-blas
		app-eselect/eselect-lapack
	)
"

QA_PREBUILT="*"
QA_TEXTRELS="*"
QA_SONAME="*"

src_install() {
	local libdir=$(get_libdir)
	local libroot=opt/intel/oneapi/mkl/${PN_VER}/lib

	if ! use static-libs; then
		rm -v "${libroot}"/{*.a,pkgconfig/*-static-*.pc} || die
	fi
	if ! use examples; then
		rm -rv "opt/intel/oneapi/mkl/${PN_VER}"/share/{mkl/benchmarks,doc/mkl/examples} || die
	fi
	if ! use gnu-openmp; then
		rm -v "${libroot}"/{*_gnu_thread.*,pkgconfig/*-gomp.pc} || die
	fi
	if use llvm-openmp; then
		# Replace Intel OpenMP with LLVM OpenMP.  We could just install
		# "openmp.pc" for that, but we don't want random packages
		# to start depending on it.
		sed -e '/Requires: openmp/d' \
			-e '/Libs:/s:$: -lomp:' \
			-i "${libroot}"/pkgconfig/*iomp.pc || die
		# Install a "libiomp5.so" symlink to make the magical lookup
		# in mkl_rt.so happy too.
		ln -s "../../../../../../usr/$(get_libdir)/libomp.so" \
			"${libroot}"/libiomp5.so || die
	else
		rm -v "${libroot}"/{*_intel_thread.*,pkgconfig/*-iomp.pc} || die
	fi
	if ! use tbb; then
		rm -v "${libroot}"/{*_tbb_thread.*,pkgconfig/*-tbb.pc} || die
	fi

	# Symlink pkgconfig and cmake files
	pushd "${libroot}/pkgconfig" >/dev/null || die
	for file in *.pc; do
		dosym "../../../${libroot}/pkgconfig/${file}" \
			"/usr/${libdir}/pkgconfig/${file}"
	done
	popd >/dev/null || die
	pushd "${libroot}/cmake/mkl" >/dev/null || die
	for file in *.cmake; do
		dosym "../../../../${libroot}/cmake/mkl/${file}" \
			"/usr/${libdir}/cmake/mkl/${file}"
	done
	popd >/dev/null || die

	# Move everything over to the image directory
	mv "${S}/"* "${ED}" || die

	# Create convenience symlink that does not include the version number
	dosym "${PN_VER}" /opt/intel/oneapi/mkl/latest

	if use eselect-ldso; then
		local lib=../../../../${libroot}/libmkl_rt.so
		dodir "/usr/${libdir}"/{blas,lapack}/mkl
		dosym "${lib}" "/usr/${libdir}/blas/mkl/libblas.so"
		dosym "${lib}" "/usr/${libdir}/blas/mkl/libblas.so.3"
		dosym "${lib}" "/usr/${libdir}/blas/mkl/libcblas.so"
		dosym "${lib}" "/usr/${libdir}/blas/mkl/libcblas.so.3"
		dosym "${lib}" "/usr/${libdir}/lapack/mkl/liblapack.so"
		dosym "${lib}" "/usr/${libdir}/lapack/mkl/liblapack.so.3"
		dosym "${lib}" "/usr/${libdir}/lapack/mkl/liblapacke.so"
		dosym "${lib}" "/usr/${libdir}/lapack/mkl/liblapacke.so.3"
	fi

	# https://www.intel.com/content/www/us/en/docs/onemkl/developer-guide-linux/2025-1/dynamic-select-the-interface-and-threading-layer.html
	local default_threading_layer
	if use llvm-openmp; then
		default_threading_layer=INTEL
	elif use gnu-openmp; then
		default_threading_layer=GNU
	elif use tbb; then
		default_threading_layer=TBB
	else
		default_threading_layer=SEQUENTIAL
	fi

	newenvd - "70intel-mkl" <<-_EOF_
		MKLROOT="${EPREFIX}/opt/intel/oneapi/mkl/${PN_VER}"
		PATH="${EPREFIX}/opt/intel/oneapi/mkl/${PN_VER}/bin"
		# we need to duplicate it in ROOTPATH for Portage to respect...
		ROOTPATH="${EPREFIX}/opt/intel/oneapi/mkl/${PN_VER}/bin"
		LDPATH="${EPREFIX}/opt/intel/oneapi/mkl/${PN_VER}/lib"
		# respect USE flags for defaults
		MKL_THREADING_LAYER=${default_threading_layer}
	_EOF_
}

pkg_postinst() {
	use eselect-ldso || return

	local libdir=$(get_libdir) me="mkl"

	# check blas
	eselect blas add ${libdir} "${EROOT}"/usr/${libdir}/blas/${me} ${me}
	local current_blas=$(eselect blas show ${libdir} | cut -d' ' -f2)
	if [[ ${current_blas} == "${me}" || -z ${current_blas} ]]; then
		eselect blas set ${libdir} ${me}
		elog "Current eselect: BLAS/CBLAS ($libdir) -> [${current_blas}]."
	else
		elog "Current eselect: BLAS/CBLAS ($libdir) -> [${current_blas}]."
		elog "To use blas [${me}] implementation, you have to issue (as root):"
		elog "\t eselect blas set ${libdir} ${me}"
	fi

	# check lapack
	eselect lapack add ${libdir} "${EROOT}"/usr/${libdir}/lapack/${me} ${me}
	local current_lapack=$(eselect lapack show ${libdir} | cut -d' ' -f2)
	if [[ ${current_lapack} == "${me}" || -z ${current_lapack} ]]; then
		eselect lapack set ${libdir} ${me}
		elog "Current eselect: LAPACK ($libdir) -> [${current_blas}]."
	else
		elog "Current eselect: LAPACK ($libdir) -> [${current_blas}]."
		elog "To use lapack [${me}] implementation, you have to issue (as root):"
		elog "\t eselect lapack set ${libdir} ${me}"
	fi
}

pkg_postrm() {
	use eselect-ldso || return

	eselect blas validate
	eselect lapack validate
}
