# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake edo rocm toolchain-funcs

DESCRIPTION="ROCm SPARSE marshalling library"
HOMEPAGE="https://github.com/ROCm/hipSPARSE"
# share some test datasets with rocSPARSE
SRC_URI="https://github.com/ROCm/hipSPARSE/archive/rocm-${PV}.tar.gz -> hipSPARSE-${PV}.tar.gz
test? (
http://sparse-files.engr.tamu.edu/MM/SNAP/amazon0312.tar.gz -> rocSPARSE_amazon0312.tar.gz
http://sparse-files.engr.tamu.edu/MM/Muite/Chebyshev4.tar.gz -> rocSPARSE_Chebyshev4.tar.gz
http://sparse-files.engr.tamu.edu/MM/FEMLAB/sme3Dc.tar.gz -> rocSPARSE_sme3Dc.tar.gz
http://sparse-files.engr.tamu.edu/MM/Williams/webbase-1M.tar.gz -> rocSPARSE_webbase-1M.tar.gz
http://sparse-files.engr.tamu.edu/MM/Bova/rma10.tar.gz -> rocSPARSE_rma10.tar.gz
http://sparse-files.engr.tamu.edu/MM/JGD_BIBD/bibd_22_8.tar.gz -> rocSPARSE_bibd_22_8.tar.gz
http://sparse-files.engr.tamu.edu/MM/Williams/mac_econ_fwd500.tar.gz -> rocSPARSE_mac_econ_fwd500.tar.gz
http://sparse-files.engr.tamu.edu/MM/Williams/mc2depi.tar.gz -> rocSPARSE_mc2depi.tar.gz
http://sparse-files.engr.tamu.edu/MM/Hamm/scircuit.tar.gz -> rocSPARSE_scircuit.tar.gz
http://sparse-files.engr.tamu.edu/MM/Sandia/ASIC_320k.tar.gz -> rocSPARSE_ASIC_320k.tar.gz
http://sparse-files.engr.tamu.edu/MM/GHS_psdef/bmwcra_1.tar.gz -> rocSPARSE_bmwcra_1.tar.gz
http://sparse-files.engr.tamu.edu/MM/HB/nos1.tar.gz -> rocSPARSE_nos1.tar.gz
http://sparse-files.engr.tamu.edu/MM/HB/nos2.tar.gz -> rocSPARSE_nos2.tar.gz
http://sparse-files.engr.tamu.edu/MM/HB/nos3.tar.gz -> rocSPARSE_nos3.tar.gz
http://sparse-files.engr.tamu.edu/MM/HB/nos4.tar.gz -> rocSPARSE_nos4.tar.gz
http://sparse-files.engr.tamu.edu/MM/HB/nos5.tar.gz -> rocSPARSE_nos5.tar.gz
http://sparse-files.engr.tamu.edu/MM/HB/nos6.tar.gz -> rocSPARSE_nos6.tar.gz
http://sparse-files.engr.tamu.edu/MM/HB/nos7.tar.gz -> rocSPARSE_nos7.tar.gz
http://sparse-files.engr.tamu.edu/MM/DNVS/shipsec1.tar.gz -> rocSPARSE_shipsec1.tar.gz
)"
S="${WORKDIR}/hipSPARSE-rocm-${PV}"

LICENSE="MIT"
SLOT="0"/$(ver_cut 1-2)
KEYWORDS="~amd64"
IUSE="benchmark test"
REQUIRED_USE="${ROCM_REQUIRED_USE}"

# It seems that the tests heavily abuse out-of-bounds array access, causing failures with hardened libc++
RESTRICT="test"

RDEPEND="
	dev-util/rocminfo:${SLOT}
	dev-util/hip:${SLOT}
	sci-libs/rocSPARSE:${SLOT}
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/rocm-cmake
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/${PN}-6.4.1-fix-filesystem.patch"
)

src_prepare() {
	# too many warnings from -Wall (applied after user CXXFLAGS)
	sed -e "s/-Wall/-Wall -Wno-unused-value/g" \
		-i clients/benchmarks/CMakeLists.txt \
		-i library/CMakeLists.txt \
		-i clients/tests/CMakeLists.txt || die

	cmake_src_prepare

	if use test; then
		mkdir -p "${BUILD_DIR}"/clients/matrices
		# compile and use the mtx2bin converter. Do not use any optimization flags!
		edo $(tc-getCXX) deps/convert.cpp -o deps/convert
		find "${WORKDIR}" -maxdepth 2 -regextype egrep -regex ".*/(.*)/\1\.mtx" -print0 |
			while IFS= read -r -d '' mtxfile; do
				destination=${BUILD_DIR}/clients/matrices/$(basename -s '.mtx' "${mtxfile}").bin
				ebegin "Converting ${mtxfile} to ${destination}"
				deps/convert "${mtxfile}" "${destination}"
				eend $?
			done
	fi
}

src_configure() {
	# Note: hipcc is enforced; clang fails when libc++ is enabled
	# with an error similar to https://github.com/boostorg/config/issues/392
	rocm_use_hipcc

	local mycmakeargs=(
		-DHIP_RUNTIME="ROCclr"
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
	)

	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}"/clients/staging || die
	edob ./hipsparse-test
}
