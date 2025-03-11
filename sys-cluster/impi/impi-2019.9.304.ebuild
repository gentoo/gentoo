# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MAGIC=17263            # initial download from registration center
PS_PV="2020.4.912"     # version of parallel studio
MY_PV=$(ver_rs 2 '-')  # 2019.9-304
MY_PV2="2020.4.304"    # wth is this? used in substitution commands

DESCRIPTION="Intel MPI library"
HOMEPAGE="https://software.intel.com/content/www/us/en/develop/tools/mpi-library.html"
SRC_URI="http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/${MAGIC}/l_mpi_${PV}.tgz -> ${P}.tar.gz"
S="${WORKDIR}"/l_mpi_${PV}

LICENSE="ISSL"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="strip"

RDEPEND="
	!sys-cluster/mpich
	!sys-cluster/mpich2
	!sys-cluster/nullmpi
	!sys-cluster/openmpi
"

QA_PREBUILT="*"
QA_TEXTRELS="*"
QA_SONAME="*"

### NOTES FOR FUTURE DEVS
# how to achieve below list of substitutions
# (1) download the package and install it manually - using their installer
#    - install it in /opt/intel
#    - make sure nothing else is there in that folder first
# (2) unpack the tarball somewhere and go inside the rpm/ directory
# (3) unpack all rpms in that folder
# (4) one by one go inside each rpm and then run the following command
#   find . -type f | while read ff; do echo "=========="; diff $ff "/"$ff; done
# (5) ????
# (5) party like its 1699

#####
# list of rpms
# mostly just need to copy paste, except for
# notes where you need to substitute in all files for that rpm
#####
#intel-comp-l-all-vars-19.1.3-304-19.1.3-304.noarch.rpm
# N/A
#intel-comp-nomcu-vars-19.1.3-304-19.1.3-304.noarch.rpm
# SUBSTITUTE(<INSTALLDIR>,/opt/intel/compilers_and_libraries_2020.4.304/linux)
#intel-compxe-pset-2020.4-912-2020.4-912.noarch.rpm
# N/A
#intel-conda-impi-devel-linux-64-shadow-package-2019.9-304-2019.9-304.x86_64.rpm
# N/A
#intel-conda-impi_rt-linux-64-shadow-package-2019.9-304-2019.9-304.x86_64.rpm
# N/A
#intel-conda-index-tool-19.1.3-304-19.1.3-304.x86_64.rpm
# N/A
#intel-imb-2019.9-304-2019.9-304.x86_64.rpm
# N/A
#intel-mpi-doc-2019-2019.9-304.x86_64.rpm
# N/A
#intel-mpi-installer-license-2019.9-304-2019.9-304.x86_64.rpm
# N/A
#intel-mpi-psxe-2019.9-912-2019.9-912.x86_64.rpm
# N/A
#intel-mpi-rt-2019.9-304-2019.9-304.x86_64.rpm
# SUBSTITUTE(I_MPI_SUBSTITUTE_INSTALLDIR,/opt/intel/compilers_and_libraries_2020.4.304/linux/mpi)
#intel-mpi-samples-2019.9-304-2019.9-304.x86_64.rpm
# N/A
#intel-mpi-sdk-2019.9-304-2019.9-304.x86_64.rpm
# SUBSTITUTE(I_MPI_SUBSTITUTE_INSTALLDIR,/opt/intel/compilers_and_libraries_2020.4.304/linux/mpi)
#intel-psxe-common-2020.4-912-2020.4-912.noarch.rpm
# SUBSTITUTE(%INSTALLDIR%,/opt/intel/parallel_studio_xe_2020.4.912)
# SUBSTITUTE(%INSTALLDIR_ROOT%,/opt/intel)

# note that the numbers are NOT the version
# create a substitute pair list
SUBS_FROM=( "<INSTALLDIR>" "I_MPI_SUBSTITUTE_INSTALLDIR" "%INSTALLDIR%" "%INSTALLDIR_ROOT%" )
SUBS_TO=(
	"/opt/intel/compilers_and_libraries_${MY_PV2}/linux"
	"/opt/intel/compilers_and_libraries_${MY_PV2}/linux/mpi"
	"/opt/intel/parallel_studio_xe_${PS_PV}"
	"/opt/intel"
)

INTEL_RPM=(
	intel-comp-l-all-vars-19.1.3-304-19.1.3-304.noarch
	intel-comp-nomcu-vars-19.1.3-304-19.1.3-304.noarch
	intel-compxe-pset-2020.4-912-2020.4-912.noarch
	intel-conda-impi-devel-linux-64-shadow-package-2019.9-304-2019.9-304.x86_64
	intel-conda-impi_rt-linux-64-shadow-package-2019.9-304-2019.9-304.x86_64
	intel-conda-index-tool-19.1.3-304-19.1.3-304.x86_64
	intel-imb-2019.9-304-2019.9-304.x86_64
	intel-mpi-doc-2019-2019.9-304.x86_64
	intel-mpi-installer-license-2019.9-304-2019.9-304.x86_64
	intel-mpi-psxe-2019.9-912-2019.9-912.x86_64
	intel-mpi-rt-2019.9-304-2019.9-304.x86_64
	intel-mpi-samples-2019.9-304-2019.9-304.x86_64
	intel-mpi-sdk-2019.9-304-2019.9-304.x86_64
	intel-psxe-common-2020.4-912-2020.4-912.noarch
)

src_unpack() {
	default
	cd "${S}"/rpm
	local rpm
	for rpm in ${INTEL_RPM[@]}; do
		elog "Unpacking RPM - ${rpm}.rpm..."
		rpmunpack ${rpm}.rpm || die
	done
}

src_install() {
	sed -e "s:@MY_PV2@:${MY_PV2}:g" \
	    "${FILESDIR}"/99impi > 99impi || die
	doenvd 99impi

	cd "${S}"/rpm
	dodir /opt/intel
	local rpm
	for rpm in "${INTEL_RPM[@]}" ; do
		cp -a "${rpm}"/. "${ED}"
	done

	# now to do substitutions
	local i=0 fvar tvar mfiles sfile
	for ((i=0;i<${#SUBS_TO[@]};i++)) ; do
		fvar="${SUBS_FROM[i]}"
		tvar="${SUBS_TO[i]}"
		elog "substituting ${fvar} to ${tvar}"
		mfiles=( $(grep -rl "$fvar" "${ED}"/opt/intel) )
		for sfile in "${mfiles[@]}"; do
			sed -e "s:${fvar}:${tvar}:g" -i "${sfile}" || die
		done
	done
}

pkg_postinst() {
	elog "Intel MPI has been installed to /opt/intel"
	elog "To activate the Intel MPI run the following command"
	elog "with the proper architecture args:"
	elog "\t $ . /opt/intel/compilers_and_libraries_${MY_PV2}/linux/bin/compilervars.sh [ arch-args ]"
}
