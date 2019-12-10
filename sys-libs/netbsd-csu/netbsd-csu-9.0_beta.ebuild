# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="crtbegin.o/crtend.o from NetBSD CSU for GCC-free toolchain"
HOMEPAGE="http://cvsweb.netbsd.org/bsdweb.cgi/src/lib/csu/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz
	test? ( https://dev.gentoo.org/~mgorny/dist/netbsd-csu-7.1-tests.tar.bz2 )"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="app-arch/xz-utils
	virtual/pmake
	test? ( sys-devel/clang )"

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

	bmake ${MAKEOPTS} "${opts[@]}" ${EXTRA_EMAKE} || die

	ln -s crtbegin.o crtbeginT.o || die
	ln -s crtend.o crtendS.o || die
}

multilib_src_test() {
	cd "${WORKDIR}"/*-tests || die

	# TODO: fix gcc support
	local -x CC=${CHOST}-clang
	local -x CXX=${CHOST}-clang++
	strip-unsupported-flags

	local cc=(
		# -B sets prefix for internal gcc/clang file lookup
		"${CC}" -B"${BUILD_DIR}"
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

	# 3. build and run the tests
	emake CC="${cc[*]}"

	local p out exp
	for p in ./hello{,-static,-dyn}; do
		if [[ ${p} == ./hello-dyn && ${ABI} == x32 ]]; then
			einfo "Skipping ${p} on x32 -- known to crash"
			continue
		fi

		ebegin "Testing ${p}"
		exp='ctor:main:dtor'
		[[ ${p} == ./hello-dyn ]] && exp=libctor:${exp}:libdtor
		if ! out=$("${p}"); then
			eend 1
			die "Test ${p} crashed for ${ABI:-${ARCH}}"
		fi

		[[ ${out} == ${exp} ]]
		if ! eend "${?}"; then
			eerror "  Expected: ${exp}"
			eerror "  Output  : ${out}"
			die "Test ${p} failed for ${ABI:-${ARCH}}"
		fi
	done

	emake clean
}

multilib_src_install() {
	dolib.a crtbegin.o crtbeginS.o crtend.o
	dosym crtbegin.o "/usr/$(get_libdir)/crtbeginT.o"
	dosym crtend.o "/usr/$(get_libdir)/crtendS.o"
}
