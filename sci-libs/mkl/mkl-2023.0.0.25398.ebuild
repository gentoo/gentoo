# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Intel Math Kernel Library"
HOMEPAGE="https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl.html"
SRC_URI="
	https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-${PN}-$(ver_cut 1-3)-$(ver_cut 1-3)-$(ver_cut 4)_amd64.deb
	https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-${PN}-devel-$(ver_cut 1-3)-$(ver_cut 1-3)-$(ver_cut 4)_amd64.deb
	https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-${PN}-common-$(ver_cut 1-3)-$(ver_cut 1-3)-$(ver_cut 4)_all.deb
	https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-${PN}-common-devel-$(ver_cut 1-3)-$(ver_cut 1-3)-$(ver_cut 4)_all.deb
"
S="${WORKDIR}"

LICENSE="ISSL"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip"

# MKL uses Intel/LLVM OpenMP by default.
# One can change the threadding layer to "gnu" or "tbb"
# through the MKL_THREADING_LAYER env var.
RDEPEND="
	app-eselect/eselect-blas
	app-eselect/eselect-lapack
	dev-cpp/tbb
	dev-libs/opencl-icd-loader
	sys-cluster/mpich
	sys-libs/libomp
"
# bug #801460
BDEPEND="
	app-arch/xz-utils[extra-filters(+)]
	app-eselect/eselect-blas
	app-eselect/eselect-lapack
"

QA_PREBUILT="*"
QA_TEXTRELS="*"
QA_SONAME="*"

src_prepare() {
	default
	# Drop conda stuff
	rm -r opt/intel/oneapi/conda_channel || die
}

src_install() {
	# Symlink pkgconfig and cmake files
	pushd "opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/pkgconfig" || die
	for file in *.pc; do
		dosym "../../../opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/pkgconfig/${file}" "/usr/share/pkgconfig/${file}"
	done
	popd || die
	pushd "opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/cmake/mkl" || die
	for file in *.cmake; do
		dosym "../../../../opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/cmake/mkl/${file}" "/usr/$(get_libdir)/cmake/mkl/${file}"
	done
	popd || die

	# Symlink files in locale directory
	pushd "opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/intel64/locale/en_US" || die
	for file in *; do
		dosym "../../../../opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/intel64/locale/en_US/${file}" "/usr/share/locale/en_US/${file}"
	done
	popd || die

	# Move everything over to the image directory
	mv "${S}/"* "${ED}" || die

	# Create convenience symlink that does not include the version number
	dosym "$(ver_cut 1-3)" /opt/intel/oneapi/mkl/latest

	dodir /usr/$(get_libdir)/blas/mkl
	dosym ../../../../opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/intel64/libmkl_rt.so usr/$(get_libdir)/blas/mkl/libblas.so
	dosym ../../../../opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/intel64/libmkl_rt.so usr/$(get_libdir)/blas/mkl/libblas.so.3
	dosym ../../../../opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/intel64/libmkl_rt.so usr/$(get_libdir)/blas/mkl/libcblas.so
	dosym ../../../../opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/intel64/libmkl_rt.so usr/$(get_libdir)/blas/mkl/libcblas.so.3
	dodir /usr/$(get_libdir)/lapack/mkl
	dosym ../../../../opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/intel64/libmkl_rt.so usr/$(get_libdir)/lapack/mkl/liblapack.so
	dosym ../../../../opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/intel64/libmkl_rt.so usr/$(get_libdir)/lapack/mkl/liblapack.so.3
	dosym ../../../../opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/intel64/libmkl_rt.so usr/$(get_libdir)/lapack/mkl/liblapacke.so
	dosym ../../../../opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/intel64/libmkl_rt.so usr/$(get_libdir)/lapack/mkl/liblapacke.so.3

	newenvd - "70intel-mkl" <<-_EOF_
		MKLROOT="${EPREFIX}/opt/intel/oneapi/mkl/$(ver_cut 1-3)"
		PATH="${EPREFIX}/opt/intel/oneapi/mkl/$(ver_cut 1-3)/bin/intel64"
		# we need to duplicate it in ROOTPATH for Portage to respect...
		ROOTPATH="${EPREFIX}/opt/intel/oneapi/mkl/$(ver_cut 1-3)/bin/intel64"
		LDPATH="${EPREFIX}/opt/intel/oneapi/mkl/$(ver_cut 1-3)/lib/intel64"
	_EOF_
}

pkg_postinst() {
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
	eselect blas validate
	eselect lapack validate
}
