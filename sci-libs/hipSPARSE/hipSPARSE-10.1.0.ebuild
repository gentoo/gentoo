# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..15} )
ROCM_VERSION=${PV}

inherit cmake edo python-any-r1 rocm toolchain-funcs

DESCRIPTION="ROCm SPARSE marshalling library"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipsparse"
# share some test datasets with rocSPARSE
SRC_URI="
	https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/hipsparse.tar.gz
		-> hipsparse-${PV}.tar.gz
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
S="${WORKDIR}/hipsparse"

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
	${PYTHON_DEPS}
	dev-build/rocm-cmake
	test? (
		dev-cpp/gtest
		$(python_gen_any_dep "dev-python/pyyaml[\${PYTHON_USEDEP}]")
	)
"

python_check_deps() {
	if use test; then
		python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]"
	fi
}

src_prepare() {
	# too many warnings from -Wall (applied after user CXXFLAGS)
	sed -e "s/-Wall/-Wall -Wno-unused-value/g" \
		-i clients/benchmarks/CMakeLists.txt \
		-i clients/common/CMakeLists.txt \
		-i library/CMakeLists.txt || die

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
	rocm_use_clang

	local mycmakeargs=(
		-DHIPSPARSE_BUILD_TESTING=$(usex test ON OFF)
		-DHIPSPARSE_ENABLE_CLIENT=$(usex benchmark ON OFF)
		-DHIPSPARSE_ENABLE_FORTRAN=OFF
		-DPython3_EXECUTABLE="${PYTHON}"
		-DROCM_SYMLINK_LIBS=OFF
	)
	use benchmark && mycmakeargs+=( -DHIPSPARSE_ENABLE_SAMPLES=OFF )

	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}"/clients/staging || die
	# upstream "standard" category; nightly and stress tests run for hours
	edob ./hipsparse-test --gtest_filter="quick/*:pre_checkin/*-*known_bug*"
}
