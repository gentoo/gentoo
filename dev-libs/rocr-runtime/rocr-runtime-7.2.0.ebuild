# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 22 )

inherit cmake flag-o-matic llvm-r2

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/ROCR-Runtime/"
	inherit git-r3
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/ROCm/rocm-systems/releases/download/rocm-${PV}/${PN}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Runtime"
HOMEPAGE="https://github.com/ROCm/rocm-systems/tree/develop/projects/rocr-runtime"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="debug"

COMMON_DEPEND="dev-libs/elfutils
	x11-libs/libdrm"
DEPEND="${COMMON_DEPEND}
	dev-libs/roct-thunk-interface:${SLOT}
	dev-libs/rocm-device-libs:${SLOT}
	$(llvm_gen_dep "
		llvm-core/clang:\${LLVM_SLOT}=
		llvm-core/lld:\${LLVM_SLOT}=
	")
"
RDEPEND="${DEPEND}"
BDEPEND="app-editors/vim-core"
	# vim-core is needed for "xxd"

PATCHES=(
	"${FILESDIR}/${PN}-7.2.0-use-system-hsakmt.patch"
)

# skip false positive detection in samples, bug #958188
CMAKE_QA_COMPAT_SKIP=1

src_prepare() {
	cd "${S}/runtime/hsa-runtime" || die

	# Gentoo installs "*.bc" to "/usr/lib" instead of a "[path]/bitcode" directory ...
	sed -e "s:-O2:--rocm-path=${EPREFIX}/usr/lib/ -O2:" -i image/blit_src/CMakeLists.txt || die

	cd "${S}" || die
	cmake_src_prepare
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/856091
	# https://github.com/ROCm/ROCR-Runtime/issues/182
	filter-lto

	use debug || append-cxxflags "-DNDEBUG"

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_rocprofiler-register=ON
		-Wno-dev
	)

	cmake_src_configure
}
