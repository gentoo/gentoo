# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Radeon Open Compute llvm,lld,clang"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm/"
SRC_URI="https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz -> llvm-rocm-ocl-${PV}.tar.gz"

LICENSE="UoI-NCSA rc BSD public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +runtime"

RDEPEND="virtual/cblas
	dev-libs/libxml2
	sys-libs/zlib
	sys-libs/ncurses:="
DEPEND="${RDEPEND}"
PDEPEND="dev-libs/rocr-runtime"

S="${WORKDIR}/llvm-project-rocm-${PV}/llvm"

PATCHES=(
	"${FILESDIR}/${PN}-3.7.0-current_pos.patch"
)

CMAKE_BUILD_TYPE=RelWithDebInfo

src_prepare() {
	cd "${WORKDIR}/llvm-project-rocm-${PV}" || die
	eapply "${FILESDIR}/${PN}-3.0.0-add_libraries.patch"
	eapply "${FILESDIR}/${PN}-4.0.0-remove-isystem-usr-include.patch"
	eapply "${FILESDIR}/${PN}-4.0.0-hip-location.patch"

	if [[ -n ${EPREFIX} ]]; then
		pushd "${S}"/../clang >/dev/null || die
		sed -i -e "s@DEFAULT_SYSROOT \"\"@DEFAULT_SYSROOT \"${EPREFIX}\"@" CMakeLists.txt
		eend $?
		ebegin "Use ${EPREFIX} as default sysroot"
		cd lib/Driver/ToolChains >/dev/null || die
		ebegin "Use dynamic linker from ${EPREFIX}"
		sed -i -e "/LibDir.*Loader/s@return \"\/\"@return \"${EPREFIX}/\"@" Linux.cpp
		eend $?

		ebegin "Remove --sysroot call on ld for native toolchain"
		sed -i -e "$(grep -n -B1 sysroot= Gnu.cpp | sed -ne '{1s/-.*//;1p}'),+1 d" Gnu.cpp
		eend $?
		popd >/dev/null || die
	fi

	# handled by sysroot, don't prefixify here.
	sed -e 's:/opt/rocm:/usr/lib/hip:' \
		-i "${S}"/../clang/lib/Driver/ToolChains/AMDGPU.cpp

	eapply_user
	cmake_src_prepare
}

src_configure() {
	PROJECTS="clang;lld"

	if usex runtime; then
		PROJECTS+=";compiler-rt"
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/roc"
		-DLLVM_ENABLE_PROJECTS="${PROJECTS}"
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
		-DLLVM_BUILD_DOCS=NO
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_SPHINX=NO
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_INSTALL_UTILS=ON
		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
	)

	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	cmake_src_configure
}

src_install() {
	cmake_src_install
	cat > "99${PN}" <<-EOF
		LDPATH="${EROOT}/usr/lib/llvm/roc/lib"
	EOF
	doenvd "99${PN}"
}
