# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/getdvhoff/getdvhoff-0.12-r1.ebuild,v 1.5 2014/02/03 09:10:58 kumba Exp $

EAPI="5"
inherit eutils toolchain-funcs

DESCRIPTION="Utility for use on LiveCDs to calculate offset of the ext2 partition for losetup"
HOMEPAGE="ftp://ftp.linux-mips.org/pub/linux/mips/people/skylark/"
SRC_URI="ftp://ftp.linux-mips.org/pub/linux/mips/people/skylark/sgibootcd-${PV}.tar.bz2"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~mips"
IUSE=""
DEPEND="dev-libs/klibc"
RESTRICT=""
S="${WORKDIR}/sgibootcd-${PV}"
MY_S="${S}/helpers"

src_compile() {
	cd ${MY_S}
	local mycc="$(tc-getCC)"
	local mysrc="getdvhoff.c"
	local klloc="/usr/lib/klibc"
	local klobjs="${klloc}/lib/crt0.o ${klloc}/lib/libc.a"
	local klcflags="-march=mips3 -Os -fno-pic -mno-abicalls -I${klloc}/include -I${klloc}/include/bits32 -D__KLIBC__ -nostdlib"

	[ -f "${MY_S}/getdvhoff" ] && rm -f ${MY_S}/${PN}
	einfo "${mycc} ${klcflags} ${mysrc} ${klobjs} -o ${PN} -N"
	${mycc} ${klcflags} ${mysrc} ${klobjs} -o ${PN} -N
}

src_install() {
	cd ${MY_S}
	dodir /usr/lib/${PN}
	cp "${MY_S}"/"${PN}" "${D}"/usr/lib/"${PN}"
}
