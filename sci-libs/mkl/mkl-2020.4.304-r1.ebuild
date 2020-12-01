# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PROVIDER_NAME=mkl
PROVIDER_LIBS=( blas lapack )
MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit library-provider chainload-provider multilib-build rpm

MAGIC=16917            # from registration center
MY_P=${P/-/_}          # mkl_2020.4.304
MY_PV=$(ver_rs 2 '-')  # 2020.4-304

DESCRIPTION="Intel Math Kernel Library"
HOMEPAGE="https://software.intel.com/en-us/intel-mkl"
SRC_URI="http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/${MAGIC}/l_${MY_P}.tgz -> ${P}.tar.gz"
S="${WORKDIR}"/l_${MY_P}

LICENSE="ISSL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"
RESTRICT="strip"

# MKL uses Intel/LLVM OpenMP by default.
# One can change the threadding layer to "gnu" or "tbb"
# through the MKL_THREADING_LAYER env var.
RDEPEND="
	sys-libs/libomp[${MULTILIB_USEDEP}]
"

QA_PREBUILT="*"
QA_TEXTRELS="*"
QA_SONAME="*"
QA_MULTILIB_PATHS="/usr/lib.*/libmkl_tbb_thread.so"

# first unpack all rpms
# find folders containing header like, static and dynamic lib files
# these are the only folders we care about
# find "${S}"/rpm -type f \( -name "*.a" -o -name "*.so" -o -wholename "*mkl/include*" \) \
#	| tr '/' ' ' | awk '{ print $2 }' | sort | uniq

# ignore all conda-* rpms
# ignore all empty rpms
# information about rest:
#
# mkl-core-ps-32bit-2020.3-279-2020.3-279.x86_64.rpm | some prebuilt benchmark executables
# psxe-common-2020.3-111-2020.3-111.noarch.rpm
# comp-l-all-vars-19.1.2-279-19.1.2-279.noarch.rpm
# comp-nomcu-vars-19.1.2-279-19.1.2-279.noarch.rpm
# mkl-cluster-c-2020.3-279-2020.3-279.noarch.rpm
# mkl-cluster-f-2020.3-279-2020.3-279.noarch.rpm
# mkl-doc-2020-2020.3-279.noarch.rpm
# mkl-common-ps-2020.3-279-2020.3-279.noarch.rpm | only contains benchmarks
# compxe-pset-2020.3-111-2020.3-111.noarch.rpm | only contains benchmarks
# mkl-doc-ps-2020-2020.3-279.noarch.rpm
# mkl-common-2020.3-279-2020.3-279.noarch.rpm | setting up environment vars (might be needed for parallel studio)
# mkl-installer-license-2020.3-279-2020.3-279.noarch.rpm | already have license
# mkl-psxe-2020.3-111-2020.3-111.noarch.rpm | useless files
# mkl-common-c-ps-2020.3-279-2020.3-279.noarch.rpm | contained in common-c

INTEL_DIST_X86_RPMS=(
	mkl-core-32bit
	mkl-core-rt-32bit
	mkl-f95-32bit
	mkl-gnu-32bit
	mkl-gnu-f-32bit
	mkl-gnu-f-rt-32bit
	mkl-gnu-rt-32bit
	mkl-tbb-32bit
	mkl-tbb-rt
	intel-openmp-32bit-19.1.3-304-19.1.3-304.x86_64.rpm
)
INTEL_DIST_AMD64_RPMS=(
	mkl-cluster
	mkl-cluster-rt
	mkl-core
	mkl-core-ps
	mkl-core-rt
	mkl-f95
	mkl-gnu
	mkl-gnu-f
	mkl-gnu-rt
	mkl-gnu-f-rt
	mkl-pgi
	mkl-pgi-rt
	mkl-tbb
	mkl-tbb-rt
	intel-openmp-19.1.3-304-19.1.3-304.x86_64.rpm
)
INTEL_DIST_DAT_RPMS=(
	mkl-common-c
	mkl-common-f
	mkl-f95-common
)

rpm_dirname() {
	local rpm="${1}" suffix="x86_64"
	if [[ $# -eq 2 ]]; then
		suffix="$2"
	fi
	if [[ ! ${rpm} =~ "rpm" ]] ; then
		rpm="intel-${rpm}-${MY_PV}-${MY_PV}.${suffix}"
	fi
	printf '%s\n' "${rpm%%.rpm}"
}

rpm_unpack() {
	local rpm="$1" suffix="x86_64"
	if [[ $# -eq 2 ]]; then
		suffix="$2"
	fi
	rpm="$(rpm_dirname $rpm $suffix)"
	elog "Unpacking - ${rpm}.rpm"
	rpmunpack "${rpm}.rpm" || die
}

src_unpack() {
	default
	cd "${S}"/rpm
	local rpm
	for rpm in ${INTEL_DIST_DAT_RPMS[@]}; do
		rpm_unpack ${rpm} noarch
	done
	if use abi_x86_64 ; then
		for rpm in ${INTEL_DIST_AMD64_RPMS[@]}; do
			rpm_unpack ${rpm}
		done
	fi
	if use abi_x86_32 ; then
		for rpm in ${INTEL_DIST_X86_RPMS[@]}; do
			rpm_unpack ${rpm}
		done
	fi
}

multilib_src_install() {
	cd "${S}"/rpm
	elog "current variant - ${MULTIBUILD_VARIANT}"
	local rpm rpm_list libdir=$(get_libdir)
	if [[ ${MULTIBUILD_VARIANT} =~ 'amd64' ]] ; then
		rpm_list="${INTEL_DIST_AMD64_RPMS[@]}"
	else
		rpm_list="${INTEL_DIST_X86_RPMS[@]}"
	fi
	for rpm in ${rpm_list} ; do
		rpm=$(rpm_dirname ${rpm})
		elog "installing libs from - ${rpm}"
		local libso liba
		for libso in $(find "${S}"/rpm/${rpm} -name "*.so") ; do
			dolib.so "${libso}"
		done
		use static-libs && \
		for liba in $(find "${S}"/rpm/${rpm} -name "*.a") ; do
			dolib.a "${liba}"
		done
	done

	local mklflags=( "-L${ED}/usr/$(get_libdir)" -lmkl_rt )
	provider-link-lib libblas.so.3    "${mklflags[@]}"
	provider-link-lib libcblas.so.3   "${mklflags[@]}"
	provider-link-lib liblapack.so.3  "${mklflags[@]}"
	provider-link-lib liblapacke.so.3 "${mklflags[@]}"

	provider-install-lib libblas.so.3
	provider-install-lib libcblas.so.3 /usr/$(get_libdir)/blas/mkl
	provider-install-lib liblapack.so.3
	provider-install-lib liblapacke.so.3 /usr/$(get_libdir)/lapack/mkl

	# for some reason pkgconfig files are only for amd64
	[[ ${MULTIBUILD_VARIANT} =~ 'amd64' ]] || return
	local pc_files=( "${FILESDIR}"/*.pc )
	insinto /usr/$(get_libdir)/pkgconfig
	for pc in "${pc_files[@]}" ; do
		doins "${pc}"
		sed -e "s:@PREFIX@:${EPREFIX}/usr:" \
		    -i "${ED}"/usr/$(get_libdir)/pkgconfig/${pc##*/} || die
	done
}

src_install() {
	# install bunch of header like files
	dodir /usr/include/mkl
	for idir in $(find "${S}"/rpm -type d -wholename "*mkl/include"); do
		cp -a "${idir}"/. "${ED}"/usr/include/mkl || die
	done

	multilib_foreach_abi multilib_src_install
}

pkg_postinst() {
	multilib_foreach_abi library-provider_pkg_postinst
}

pkg_postrm() {
	multilib_foreach_abi library-provider_pkg_postrm
}
