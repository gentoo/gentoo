# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake llvm

LLVM_MAX_SLOT=17

DESCRIPTION="Radeon Open Compute hipcc"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/hipcc"

KEYWORDS="~amd64"
SRC_URI="https://github.com/ROCm-Developer-Tools/hipcc/archive/refs/tags/rocm-${PV}.tar.gz -> hipcc-${PV}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="debug test"
RESTRICT="!test? ( test )"

S=${WORKDIR}/HIPCC-rocm-${PV}

DEPEND="<sys-devel/llvm-18:=
	<sys-devel/clang-18:=
	"
RDEPEND="${DEPEND}
	!<dev-util/hip-5.7"

PATCHES=(
	"${FILESDIR}/${PN}-5.7.1-fno-stack-protector.patch"
	"${FILESDIR}/${PN}-5.7.1-hipcc-hip-version.patch"
)

src_prepare() {
	cmake_src_prepare

	sed -e "s:\$ROCM_PATH/llvm/bin:$(get_llvm_prefix ${LLVM_MAX_SLOT})/bin:" \
		-i bin/hipvars.pm || die

	sed -e "s:\$ENV{'DEVICE_LIB_PATH'}:'${EPREFIX}/usr/lib/amdgcn/bitcode':" \
		-e "s:\$ENV{'HIP_LIB_PATH'}:'${EPREFIX}/usr/$(get_libdir)':" \
		-e "/HIP.*FLAGS.*isystem.*HIP_INCLUDE_PATH/d" \
		-i bin/hipcc.pl || die
}

src_install() {
	cmake_src_install
	# rm unwanted copy
	rm -rf "${ED}/usr/hip" || die
}
