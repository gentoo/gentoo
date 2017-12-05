# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bsdmk multilib-minimal toolchain-funcs

DESCRIPTION="crtbegin.o/crtend.o from NetBSD CSU for GCC-free toolchain"
HOMEPAGE="http://cvsweb.netbsd.org/bsdweb.cgi/src/lib/csu/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/xz-utils"

S=${WORKDIR}/${P}/lib/csu

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	local inc_arch=${ABI:-${ARCH}}

	# rewrite ARCH to match NetBSD includes
	case "${inc_arch}" in
		x86) inc_arch=i386;;
		# x32 seems to be equivalent to amd64 as far as we're concerned
		x32) inc_arch=amd64;;
		arm64) inc_arch=aarch64;;
	esac

	# we need arch-specific headers for some assembler macros
	if [[ ! -d ${WORKDIR}/${P}/sys/arch/${inc_arch} ]]; then
		die "Unexpected ABI/ARCH: ${inc_arch}, please report"
	fi
	ln -s "${WORKDIR}/${P}/sys/arch/${inc_arch}/include" common/machine || die

	local opts=(
		CC="$(tc-getCC)"
		OBJCOPY="$(tc-getOBJCOPY)"

		MKPIC=yes
		MKSTRIPIDENT=no
	)
	# rewrite MACHINE_ARCH to match names used in CSU
	case "${inc_arch}" in
		amd64) opts+=( MACHINE_ARCH=x86_64 );;
		*) opts+=( MACHINE_ARCH="${inc_arch}" );;
	esac

	# we only need those files; crt1 and friends are provided by libc
	opts+=( crtbegin.o crtbeginS.o crtend.o )

	bsdmk_src_compile "${opts[@]}"
}

multilib_src_test() {
	local cc=(
		# -B sets prefix for internal gcc/clang file lookup
		$(tc-getCC) -B"${BUILD_DIR}"
	)

	# 1. figure out the correct location for crt* files
	if tc-is-gcc; then
		# gcc requires crt*.o in multi-dir
		local multidir=$("${cc[@]}" -print-multi-directory)
		if [[ ${multidir} != . ]]; then
			ln -s . "${multidir}" || die
		fi
	elif tc-is-clang; then
		# clang is entirely happy with crt*.o in -B
		:
	else
		eerror "Unsupported compiler for tests ($(tc-getCC))"
		return
	fi

	# 2. verify that the compiler can use our crtbegin/crtend
	local crtbegin=$("${cc[@]}" -print-file-name=crtbegin.o) || die
	local crtend=$("${cc[@]}" -print-file-name=crtend.o) || die
	if [[ ! ${crtbegin} -ef ${BUILD_DIR}/crtbegin.o ]]; then
		die "Compiler uses wrong crtbegin: ${crtbegin}"
	fi
	if [[ ! ${crtend} -ef ${BUILD_DIR}/crtend.o ]]; then
		die "Compiler uses wrong crtend: ${crtend}"
	fi

	cat > hello.c <<-EOF || die
		#include <stdio.h>

		__attribute__((constructor))
		static void ctor_test()
		{
			fputs("ctor:", stdout);
		}

		__attribute__((destructor))
		static void dtor_test()
		{
			fputs(":dtor", stdout);
		}

		int main()
		{
			fputs("main", stdout);
			return 0;
		}
	EOF

	emake -f /dev/null CC="${cc[*]}" hello

	local out=$(./hello) || die
	if [[ ${out} != ctor:main:dtor ]]; then
		eerror "Invalid output from the test case."
		eerror "  Expected: ctor:main:dtor"
		eerror "  Output  : ${out}"
		die "Test failed for ${ABI:-${ARCH}}"
	fi
}

multilib_src_install() {
	dolib crtbegin.o crtbeginS.o crtend.o
	dosym crtbegin.o "/usr/$(get_libdir)/crtbeginT.o"
	dosym crtend.o "/usr/$(get_libdir)/crtendS.o"
}
