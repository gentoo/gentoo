# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DEB_VER=6.2
DESCRIPTION="edit disk partitions on Acorn machines"
HOMEPAGE="http://www.arm.linux.org.uk/"
SRC_URI="ftp://ftp.arm.linux.org.uk/pub/armlinux/source/other/${P}.tar.gz
	mirror://debian/pool/main/a/acorn-fdisk/acorn-fdisk_${PV}-${DEB_VER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc s390 sh sparc x86"
IUSE=""

src_prepare() {
	default
	eapply "${WORKDIR}"/acorn-fdisk_${PV}-${DEB_VER}.diff

	find . -name Makefile -exec sed -i \
		-e "s:-O2 -Wall\( -g\)\?::" \
		-e "/^CFLAGS/s:=:+=:" \
		-e "/^LDFLAGS/s:=:+=:" \
		-e '/^STRIP/s:strip:true:' {} + || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)"
}

src_install() {
	into /
	newsbin fdisk ${PN}
	dosym ${PN} /sbin/acorn-fdisk
	dodoc ChangeLog README debian/changelog
}
