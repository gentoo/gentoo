# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Utilities for signing and verifying files for UEFI Secure Boot"
HOMEPAGE="https://launchpad.net/ubuntu/+source/sbsigntool"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
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

src_prepare() {
	local iarch
	case ${ARCH} in
		ia64)  iarch=ia64 ;;
		x86)   iarch=ia32 ;;
		amd64) iarch=x86_64 ;;
		*)     die "unsupported architecture: ${ARCH}" ;;
	esac
	sed -i "/^EFI_ARCH=/s:=.*:=${iarch}:" configure || die
	sed -i 's/-m64$/& -march=x86-64/' tests/Makefile.in || die
	sed -i "/^AR /s:=.*:= $(tc-getAR):" lib/ccan/Makefile.in || die #481480
	epatch "${FILESDIR}"/0002-image.c-clear-image-variable.patch
	epatch "${FILESDIR}"/0003-Fix-for-multi-sign.patch
}
