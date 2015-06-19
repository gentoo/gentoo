# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/efibootmgr/efibootmgr-0.6.0.ebuild,v 1.1 2013/11/06 10:41:09 jlec Exp $

EAPI=5

inherit flag-o-matic toolchain-funcs eutils

DESCRIPTION="Interact with the EFI Boot Manager"
HOMEPAGE="http://developer.intel.com/technology/efi"
SRC_URI="http://linux.dell.com/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

RDEPEND="sys-apps/pciutils"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e "/^LIBS/s:=.*:=$($(tc-getPKG_CONFIG) libpci --libs):" \
		src/efibootmgr/module.mk || die

	epatch "${FILESDIR}/${PN}-error-reporting.patch"
}

src_compile() {
	strip-flags
	tc-export CC
	emake EXTRA_CFLAGS="${CFLAGS}"
}

src_install() {
	# build system uses perl, so just do it ourselves
	dosbin src/efibootmgr/efibootmgr
	doman src/man/man8/efibootmgr.8
	dodoc AUTHORS README doc/ChangeLog doc/TODO
}
