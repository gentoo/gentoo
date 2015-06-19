# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/yaboot/yaboot-1.3.17-r2.ebuild,v 1.9 2015/05/17 05:02:02 vapier Exp $

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="PPC Bootloader"
HOMEPAGE="http://yaboot.ozlabs.org"
SRC_URI="http://yaboot.ozlabs.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ppc -ppc64"
IUSE="ibm"

DEPEND="sys-apps/powerpc-utils
	sys-fs/e2fsprogs[static-libs]"
RDEPEND="!sys-boot/yaboot-static
	!ibm? (
		sys-fs/hfsutils
		sys-fs/hfsplusutils
		sys-fs/mac-fdisk
	)"

src_unpack() {
	default
	cd "${S}"
	cp "${FILESDIR}/new-ofpath" "${S}/ybin/ofpath"
}

src_prepare() {
	# No need to hardcode this path -- the compiler already knows to use it.
	# Error only on real errors, for prom printing format compile failure.
	sed -i \
		-e 's:-I/usr/include::' \
		-e 's:-Werror:-Wno-error:g' \
		Makefile || die

	# dual boot patch
	epatch "${FILESDIR}/yabootconfig-1.3.13.patch"
	epatch "${FILESDIR}/chrpfix.patch"
	epatch "${FILESDIR}/${P}-nopiessp-gcc4.patch"
	epatch "${FILESDIR}/${PN}-stubfuncs.patch"

	# Fix the devspec path on newer kernels
	epatch "${FILESDIR}/new-ofpath-devspec.patch"
}

src_compile() {
	unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
	emake PREFIX=/usr MANDIR=share/man CC="$(tc-getCC)" LD="$(tc-getLD)"
}

src_install() {
	sed -i -e 's/\/local//' etc/yaboot.conf || die
	emake ROOT="${D}" PREFIX=/usr MANDIR=share/man install
	mv "${ED}"/etc/yaboot.conf{,.sample} || die
}
