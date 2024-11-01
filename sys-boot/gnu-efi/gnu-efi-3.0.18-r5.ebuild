# Copyright 2004-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Library for build EFI Applications"
HOMEPAGE="https://sourceforge.net/projects/gnu-efi/"
SRC_URI="https://downloads.sourceforge.net/gnu-efi/${P}.tar.bz2"

# inc/, lib/ dirs (README.efilib)
# - BSD-2
# gnuefi dir:
# - BSD (3-cluase): crt0-efi-ia32.S
# - GPL-2+ : setjmp_ia32.S
LICENSE="GPL-2+ BSD BSD-2"
SLOT="0"
KEYWORDS="-* ~amd64 arm ~arm64 ~riscv x86"
IUSE="abi_x86_32 abi_x86_64 custom-cflags"
REQUIRED_USE="
	amd64? ( || ( abi_x86_32 abi_x86_64 ) )
	x86? ( || ( abi_x86_32 abi_x86_64 ) )
"

# for ld.bfd and objcopy
BDEPEND="sys-devel/binutils"

# These objects get run early boot (i.e. not inside of Linux),
# so doing these QA checks on them doesn't make sense.
QA_EXECSTACK="usr/*/lib*efi.a:* usr/*/crt*.o"
RESTRICT="strip"

PATCHES=(
	"${FILESDIR}"/${P}-clang.patch
	"${FILESDIR}"/${PN}-3.0.18-remove-linux-headers.patch
)

check_and_set_objcopy() {
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		# bug #931792
		# llvm-objcopy does not support EFI target, try to use binutils objcopy or fail
		tc-export OBJCOPY
		OBJCOPY="${OBJCOPY/llvm-/}"
		# Test OBJCOPY to see if it supports EFI targets, and return if it does
		LC_ALL=C "${OBJCOPY}" --help | grep -q '\<pei-' && return 0
		# If OBJCOPY does not support EFI targets, it is possible that the 'objcopy' on our path is
		# still LLVM if the 'binutils-plugin' USE flag is set. In this case, we check to see if the
		# '(prefix)/usr/bin/objcopy' binary is available (it should be, it's a dependency), and if
		# so, we use the absolute path explicitly.
		local binutils_objcopy="${EPREFIX}"/usr/bin/"${OBJCOPY}"
		if [[ -e "${binutils_objcopy}" ]]; then
			OBJCOPY="${binutils_objcopy}"
		fi
		if ! use arm && ! use riscv; then
			# bug #939338
			# objcopy does not understand PE/COFF on these arches: arm32, riscv64 and mips64le
			# gnu-efi containes a workaround
			LC_ALL=C "${OBJCOPY}" --help | grep -q '\<pei-' || die "${OBJCOPY} (objcopy) does not support EFI target"
		fi
	fi
}

check_compiler() {
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		tc-is-gcc || tc-is-clang || die "Unsupported compiler"
	fi
}

pkg_pretend() {
	check_compiler
}

pkg_setup() {
	check_compiler
	check_and_set_objcopy
}

src_prepare() {
	default
	sed -i -e "s/-Werror//" Make.defaults || die
}

efimake() {
	local arch=
	case ${CHOST} in
		arm*) arch=arm ;;
		aarch64*) arch=aarch64 ;;
		ia64*) arch=ia64 ;;
		i?86*) arch=ia32 ;;
		riscv64*) arch=riscv64;;
		x86_64*) arch=x86_64 ;;
		*) die "Unknown CHOST" ;;
	esac

	local args=(
		ARCH="${arch}"
		HOSTCC="${BUILD_CC}"
		CC="${CC}"
		AS="${AS}"
		LD="${LD}"
		AR="${AR}"
		OBJCOPY="${OBJCOPY}"
		PREFIX="${EPREFIX}/usr"
		LIBDIR='$(PREFIX)'/$(get_libdir)
	)
	emake -j1 "${args[@]}" "$@"
}

src_compile() {
	tc-export BUILD_CC AR AS CC LD OBJCOPY

	if ! use custom-cflags; then
		unset CFLAGS CPPFLAGS LDFLAGS
	fi

	# work around musl: include first the compiler include dir, then the system one
	# bug #933080, #938012
	local CPPINCLUDEDIR
	if tc-is-gcc; then
		CPPINCLUDEDIR=$(LC_ALL=C ${CC} -print-search-dirs 2> /dev/null | grep ^install: | cut -f2 -d' ')/include
	elif tc-is-clang; then
		CPPINCLUDEDIR=$(LC_ALL=C ${CC} -print-resource-dir 2> /dev/null)/include
	fi
	append-cflags "-nostdinc -isystem ${CPPINCLUDEDIR} -isystem ${ESYSROOT}/usr/include"

	if use amd64 || use x86; then
		use abi_x86_32 && CHOST=i686 ABI=x86 efimake
		use abi_x86_64 && CHOST=x86_64 ABI=amd64 efimake
	else
		efimake
	fi
}

src_install() {
	if use amd64 || use x86; then
		use abi_x86_32 && CHOST=i686 ABI=x86 efimake INSTALLROOT="${D}" install
		use abi_x86_64 && CHOST=x86_64 ABI=amd64 efimake INSTALLROOT="${D}" install
	else
		efimake INSTALLROOT="${D}" install
	fi
	einstalldocs
}
