# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Library for build EFI Applications"
HOMEPAGE="http://developer.intel.com/technology/efi"
SRC_URI="ftp://ftp.hpl.hp.com/pub/linux-ia64/gnu-efi-3.0a.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ia64 x86"
IUSE=""

DEPEND="sys-apps/pciutils"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/gnu-efi-3.0a-lds-redhat.patch
}

src_compile() {
	local iarch
	case $ARCH in
		ia64) iarch=ia64 ;;
		x86)  iarch=ia32 ;;
		*)    die "unknown architecture: $ARCH" ;;
	esac
	emake CC="$(tc-getCC)" ARCH=${iarch} -j1 || die "emake failed"
}

src_install() {
	make install INSTALLROOT="${D}"/usr || die "install failed"
	dodoc README* ChangeLog
}
