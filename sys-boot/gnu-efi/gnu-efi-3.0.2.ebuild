# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit epatch multilib

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
KEYWORDS="-* ~amd64 ia64 ~x86"
IUSE=""

DEPEND="sys-apps/pciutils"
RDEPEND=""

# These objects get run early boot (i.e. not inside of Linux),
# so doing these QA checks on them doesn't make sense.
QA_EXECSTACK="usr/*/lib*efi.a:* usr/*/crt*.o"

src_prepare() {
	epatch_user
}

_emake() {
	emake \
		prefix=${CHOST}- \
		ARCH=${iarch} \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR='$(PREFIX)/'"$(get_libdir)" \
		"$@"
}

src_compile() {
	case ${ARCH} in
		ia64)  iarch=ia64 ;;
		x86)   iarch=ia32 ;;
		amd64) iarch=x86_64 ;;
		*)     die "unknown architecture: $ARCH" ;;
	esac
	# The lib subdir uses unsafe archive targets, and
	# the apps subdir needs gnuefi subdir
	_emake -j1
}

src_install() {
	_emake install PREFIX=/usr INSTALLROOT="${D}"
	dodoc README* ChangeLog
}
