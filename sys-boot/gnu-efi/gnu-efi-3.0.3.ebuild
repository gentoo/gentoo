# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="Library for build EFI Applications"
HOMEPAGE="http://gnu-efi.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnu-efi/${P}.tar.bz2"

# inc/, lib/ dirs (README.efilib)
# - BSD-2
# gnuefi dir:
# - BSD (3-cluase): crt0-efi-ia32.S
# - GPL-2+ : setjmp_ia32.S
LICENSE="GPL-2+ BSD BSD-2"
SLOT="0"
# IA64 build is broken in setjmp code:
# https://sourceforge.net/p/gnu-efi/bugs/9/
KEYWORDS="-* amd64 ~arm ~arm64 -ia64 x86"
IUSE="abi_x86_32 abi_x86_64"

DEPEND="sys-apps/pciutils"
RDEPEND=""

# These objects get run early boot (i.e. not inside of Linux),
# so doing these QA checks on them doesn't make sense.
QA_EXECSTACK="usr/*/lib*efi.a:* usr/*/crt*.o"
RESTRICT="strip"

efimake() {
	local arch=
	case ${CHOST} in
		arm*) arch=arm ;;
		aarch64*) arch=aarch64 ;;
		ia64*) arch=ia64 ;;
		i?86*) arch=ia32 ;;
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
		PREFIX="${EPREFIX}/usr"
		LIBDIR='$(PREFIX)'/$(get_libdir)
	)
	emake -j1 "${args[@]}" "$@"
}

src_compile() {
	tc-export BUILD_CC AR AS CC LD

	# https://bugs.gentoo.org/607992
	filter-mfpmath sse

	if [[ ${CHOST} == x86_64* ]]; then
		use abi_x86_32 && CHOST=i686 ABI=x86 efimake
		use abi_x86_64 && efimake
	else
		efimake
	fi
}

src_install() {
	if [[ ${CHOST} == x86_64* ]]; then
		use abi_x86_32 && CHOST=i686 ABI=x86 efimake INSTALLROOT="${D}" install
		use abi_x86_64 && efimake INSTALLROOT="${D}" install
	else
		efimake INSTALLROOT="${D}" install
	fi
	dodoc README* ChangeLog
}
