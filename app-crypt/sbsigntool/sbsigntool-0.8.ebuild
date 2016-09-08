# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs autotools-utils

DESCRIPTION="Utilities for signing and verifying files for UEFI Secure Boot"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/jejb/sbsigntools.git/"
SRC_URI="https://dev.gentoo.org/~tamiko/distfiles/${P}.tar.gz
	https://dev.gentoo.org/~tamiko/distfiles/${P}-ccan.tar.gz"

LICENSE="GPL-3 LGPL-3 LGPL-2.1 CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-apps/util-linux"
DEPEND="${RDEPEND}
	sys-apps/help2man
	sys-boot/gnu-efi
	sys-libs/binutils-libs
	virtual/pkgconfig"

S="${WORKDIR}"

src_prepare() {
	local iarch
	case ${ARCH} in
		ia64)  iarch=ia64 ;;
		x86)   iarch=ia32 ;;
		amd64) iarch=x86_64 ;;
		*)     die "unsupported architecture: ${ARCH}" ;;
	esac
	sed -i "/^EFI_ARCH=/s:=.*:=${iarch}:" configure.ac || die
	sed -i 's/-m64$/& -march=x86-64/' tests/Makefile.am || die
	sed -i "/^AR /s:=.*:= $(tc-getAR):" lib/ccan/Makefile.in || die #481480

	AUTOTOOLS_IN_SOURCE_BUILD=1
	AUTOTOOLS_AUTORECONF=true
	autotools-utils_src_prepare
}
