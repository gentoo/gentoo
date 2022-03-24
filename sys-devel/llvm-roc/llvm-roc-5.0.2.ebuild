# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Radeon Open Compute llvm,lld,clang"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm/"
SRC_URI="https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz -> llvm-rocm-ocl-${PV}.tar.gz"

LICENSE="UoI-NCSA rc BSD public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +runtime"

RDEPEND="
	dev-libs/libxml2
	sys-libs/zlib
	sys-libs/ncurses:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/llvm-project-rocm-${PV}/llvm"

PATCHES=(
	"${FILESDIR}/${PN}-4.2.0-current_pos.patch"
	"${FILESDIR}/${PN}-5.0.0-linkdl.patch"
)

CMAKE_BUILD_TYPE=RelWithDebInfo

src_prepare() {
	pushd "${WORKDIR}/llvm-project-rocm-${PV}" || die
	eapply "${FILESDIR}/${PN}-4.0.0-remove-isystem-usr-include.patch"
	eapply "${FILESDIR}/${PN}-5.0.0-hip-location.patch"
	eapply "${FILESDIR}/${PN}-5.0.0-add_GNU-stack.patch"
	popd || die

	if [[ -n ${EPREFIX} ]]; then
		pushd "${S}"/../clang >/dev/null || die
		sed -i -e "s@DEFAULT_SYSROOT \"\"@DEFAULT_SYSROOT \"${EPREFIX}\"@" CMakeLists.txt || die
		eend $?
		ebegin "Use "${EPREFIX}" as default sysroot"
		cd lib/Driver/ToolChains >/dev/null || die
		ebegin "Use dynamic linker from ${EPREFIX}"
		sed -i -e "/LibDir.*Loader/s@return \"\/\"@return \"${EPREFIX}/\"@" Linux.cpp || die
		eend $?

		ebegin "Remove --sysroot call on ld for native toolchain"
		sed -i -e "$(grep -n -B1 sysroot= Gnu.cpp | sed -ne '{1s/-.*//;1p}'),+1 d" Gnu.cpp || die
		eend $?
		popd >/dev/null || die
	fi

	# handled by sysroot, don't prefixify here.
	sed -e 's:/opt/rocm:/usr/lib/hip:' \
		-i "${S}"/../clang/lib/Driver/ToolChains/AMDGPU.cpp || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	PROJECTS="clang;lld;llvm"

	if usex runtime; then
		PROJECTS+=";compiler-rt"
	fi

	local mycmakeargs=(
		-Wno-dev
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/roc"
		-DCMAKE_DISABLE_FIND_PACKAGE_CUDA=ON
		-DLLVM_ENABLE_PROJECTS="${PROJECTS}"
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
		-DLLVM_BUILD_DOCS=NO
		-DLLVM_ENABLE_BINDINGS=OFF
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_SPHINX=NO
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_BUILD_UTILS=ON
		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
	)

	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	cmake_src_configure
}

src_install() {
	cmake_src_install
	cat > "99${PN}" <<-EOF
		LDPATH="${EPREFIX}/usr/lib/llvm/roc/lib"
	EOF
	doenvd "99${PN}"
}
