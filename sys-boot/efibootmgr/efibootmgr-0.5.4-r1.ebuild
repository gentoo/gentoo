# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic toolchain-funcs eutils

DESCRIPTION="Interact with the EFI Boot Manager"
HOMEPAGE="http://developer.intel.com/technology/efi"
SRC_URI="http://linux.dell.com/efibootmgr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 x86"
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

src_configure() {
	strip-flags
	tc-export CC
}

src_compile() {
	emake EXTRA_CFLAGS="${CFLAGS}"
}

src_install() {
	# build system uses perl, so just do it ourselves
	dosbin src/efibootmgr/efibootmgr
	doman src/man/man8/efibootmgr.8
	dodoc AUTHORS README doc/ChangeLog doc/TODO
}
