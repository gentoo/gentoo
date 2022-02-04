# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="ROCm SPARSE marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipSPARSE"
# share some test datasets with rocSPARSE
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipSPARSE/archive/rocm-${PV}.tar.gz -> hipSPARSE-$(ver_cut 1-2).tar.gz
test? (
https://sparse.tamu.edu/MM/SNAP/amazon0312.tar.gz -> rocSPARSE_amazon0312.tar.gz
https://sparse.tamu.edu/MM/Muite/Chebyshev4.tar.gz -> rocSPARSE_Chebyshev4.tar.gz
https://sparse.tamu.edu/MM/FEMLAB/sme3Dc.tar.gz -> rocSPARSE_sme3Dc.tar.gz
https://sparse.tamu.edu/MM/Williams/webbase-1M.tar.gz -> rocSPARSE_webbase-1M.tar.gz
https://sparse.tamu.edu/MM/Bova/rma10.tar.gz -> rocSPARSE_rma10.tar.gz
https://sparse.tamu.edu/MM/JGD_BIBD/bibd_22_8.tar.gz -> rocSPARSE_bibd_22_8.tar.gz
https://sparse.tamu.edu/MM/Williams/mac_econ_fwd500.tar.gz -> rocSPARSE_mac_econ_fwd500.tar.gz
https://sparse.tamu.edu/MM/Williams/mc2depi.tar.gz -> rocSPARSE_mc2depi.tar.gz
https://sparse.tamu.edu/MM/Hamm/scircuit.tar.gz -> rocSPARSE_scircuit.tar.gz
https://sparse.tamu.edu/MM/Sandia/ASIC_320k.tar.gz -> rocSPARSE_ASIC_320k.tar.gz
https://sparse.tamu.edu/MM/GHS_psdef/bmwcra_1.tar.gz -> rocSPARSE_bmwcra_1.tar.gz
https://sparse.tamu.edu/MM/HB/nos1.tar.gz -> rocSPARSE_nos1.tar.gz
https://sparse.tamu.edu/MM/HB/nos2.tar.gz -> rocSPARSE_nos2.tar.gz
https://sparse.tamu.edu/MM/HB/nos3.tar.gz -> rocSPARSE_nos3.tar.gz
https://sparse.tamu.edu/MM/HB/nos4.tar.gz -> rocSPARSE_nos4.tar.gz
https://sparse.tamu.edu/MM/HB/nos5.tar.gz -> rocSPARSE_nos5.tar.gz
https://sparse.tamu.edu/MM/HB/nos6.tar.gz -> rocSPARSE_nos6.tar.gz
https://sparse.tamu.edu/MM/HB/nos7.tar.gz -> rocSPARSE_nos7.tar.gz
https://sparse.tamu.edu/MM/DNVS/shipsec1.tar.gz -> rocSPARSE_shipsec1.tar.gz
)"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"/$(ver_cut 1-2)
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="dev-util/rocminfo:${SLOT}
		dev-util/hip:${SLOT}
		sci-libs/rocSPARSE:${SLOT}"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/rocm-cmake:${SLOT}
	test? ( dev-cpp/gtest )"

S="${WORKDIR}/hipSPARSE-rocm-${PV}"

PATCHES=( "${FILESDIR}/${PN}-4.3.0-remove-matrices-unpacking.patch" )

src_prepare() {
	sed -e "s/PREFIX hipsparse//" \
		-e "/<INSTALL_INTERFACE/s,include,include/hipsparse," \
		-e "s:rocm_install_symlink_subdir(hipsparse):#rocm_install_symlink_subdir(hipsparse):" \
		-i library/CMakeLists.txt || die

	# remove GIT dependency
	sed -e "/find_package(Git/d" -i cmake/Dependencies.cmake || die

	if use test; then
		mkdir -p "${BUILD_DIR}"/clients/matrices
		# compile and use the mtx2bin converter. Do not use any optimization flags!
		ebegin "$(tc-getCXX) deps/convert.cpp -o deps/convert"
		$(tc-getCXX) deps/convert.cpp -o deps/convert
		eend $?
		find "${WORKDIR}" -maxdepth 2 -regextype egrep -regex ".*/(.*)/\1\.mtx" -print0 |
			while IFS= read -r -d '' mtxfile; do
				destination=${BUILD_DIR}/clients/matrices/$(basename -s '.mtx' ${mtxfile}).bin
				ebegin "Converting ${mtxfile} to ${destination}"
				deps/convert ${mtxfile} ${destination}
				eend
			done
	fi
	eapply_user
	cmake_src_prepare
}

src_configure() {
	# Grant access to the device
	addwrite /dev/kfd
	addpredict /dev/dri/

	# Compiler to use
	export CXX=hipcc

	local mycmakeargs=(
		-DHIP_RUNTIME="ROCclr"
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DCMAKE_SKIP_RPATH="ON"
		-DCMAKE_INSTALL_INCLUDEDIR=include/hipsparse
		${AMDGPU_TARGETS+-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"}
		-D__skip_rocmclang="ON" ## fix cmake-3.21 configuration issue caused by officialy support programming language "HIP"
	)

	cmake_src_configure
}

src_test() {
	addwrite /dev/kfd
	addwrite /dev/dri/
	cd "${BUILD_DIR}/clients/staging" || die
	./hipsparse-test || die
}
