# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev llvm.org toolchain-funcs

DESCRIPTION="Compiler runtime library for clang, compatible with libgcc_s"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"

DEPEND="
	llvm-runtimes/compiler-rt:${LLVM_MAJOR}
	=llvm-runtimes/libunwind-${PV}[static-libs]
	!!sys-devel/gcc
"
BDEPEND="
	llvm-core/clang:${LLVM_MAJOR}
"

LLVM_COMPONENTS=( llvm-libgcc )
llvm.org_set_globals

src_compile() {
	local -x CC=${CTARGET}-clang CXX=${CTARGET}-clang++
	local libdir=$(get_libdir)
	local rtlib=$("${CTARGET}-clang" --print-libgcc-file-name)
	$(tc-getCPP) \
		"${WORKDIR}/llvm-libgcc/gcc_s.ver.in" \
		-o gcc_s.ver || die
	$(tc-getCC) -nostdlib \
		${LDFLAGS} \
		-Wl,--version-script,gcc_s.ver \
		-Wl,--whole-archive \
		"${EPREFIX}${rtlib}" \
		"${EPREFIX}/usr/${libdir}/libunwind.a" \
		-Wl,-soname,libgcc_s.so.1.0 \
		-lc -shared \
		-o libgcc_s.so.1.0 || die
}

src_install() {
	local libdir=$(get_libdir)
	local rtlib=$("${CTARGET}-clang" --print-libgcc-file-name)
	dolib.so libgcc_s.so.1.0
	dosym "${rtlib}" "/usr/${libdir}/libgcc.a"
	dosym libgcc_s.so.1.0 "/usr/${libdir}/libgcc_s.so.1"
	dosym libgcc_s.so.1 "/usr/${libdir}/libgcc_s.so"
	dosym libunwind.a "/usr/${libdir}/libgcc_eh.a"
}
