# Copyright 2004-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

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
KEYWORDS="-* ~amd64 ~arm ~arm64 ~ia64 ~riscv ~x86"
IUSE="abi_x86_32 abi_x86_64 custom-cflags"
REQUIRED_USE="
	amd64? ( || ( abi_x86_32 abi_x86_64 ) )
	x86? ( || ( abi_x86_32 abi_x86_64 ) )
"

# These objects get run early boot (i.e. not inside of Linux),
# so doing these QA checks on them doesn't make sense.
QA_EXECSTACK="usr/*/lib*efi.a:* usr/*/crt*.o"
RESTRICT="strip"

PATCHES=(
	"${FILESDIR}"/${P}-clang.patch
)

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
