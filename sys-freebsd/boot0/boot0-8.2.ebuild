# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-freebsd/boot0/boot0-8.2.ebuild,v 1.2 2011/07/25 10:26:26 naota Exp $

EAPI=2

inherit bsdmk freebsd flag-o-matic

DESCRIPTION="FreeBSD's bootloader"
SLOT="0"
KEYWORDS="~sparc-fbsd ~x86-fbsd"

IUSE="bzip2 ieee1394 tftp zfs"

SRC_URI="mirror://gentoo/${SYS}.tar.bz2"

RDEPEND=""
DEPEND="=sys-freebsd/freebsd-mk-defs-${RV}*
	=sys-freebsd/freebsd-lib-${RV}*"

S="${WORKDIR}/sys/boot"

PATCHES=( "${FILESDIR}"/${P}-zfsboot-makefile.patch )

boot0_use_enable() {
	use ${1} && mymakeopts="${mymakeopts} LOADER_${2}_SUPPORT=\"yes\""
}

pkg_setup() {
	boot0_use_enable ieee1394 FIREWIRE
	boot0_use_enable zfs ZFS
	boot0_use_enable tftp TFTP
	boot0_use_enable bzip2 BZIP2
}

src_prepare() {
	sed -e '/-fomit-frame-pointer/d' -e '/-mno-align-long-strings/d' \
		-i "${S}"/i386/boot2/Makefile \
		-i "${S}"/i386/gptboot/Makefile \
		-i "${S}"/i386/gptzfsboot/Makefile \
		-i "${S}"/i386/zfsboot/Makefile || die
}

src_compile() {
	strip-flags
	append-flags "-I/usr/include/libstand/"
	append-flags "-fno-strict-aliasing"
	NOFLAGSTRIP="yes" freebsd_src_compile
}

src_install() {
	dodir /boot/defaults
	mkinstall FILESDIR=/boot || die "mkinstall failed"
}
