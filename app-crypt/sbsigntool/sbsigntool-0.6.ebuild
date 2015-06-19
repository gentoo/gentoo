# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/sbsigntool/sbsigntool-0.6.ebuild,v 1.4 2013/09/05 07:31:21 vapier Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="Utilities for signing and verifying files for UEFI Secure Boot"
HOMEPAGE="https://launchpad.net/ubuntu/+source/sbsigntool"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-libs/openssl
	sys-apps/util-linux"
DEPEND="${RDEPEND}
	sys-apps/help2man
	sys-boot/gnu-efi
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
}
