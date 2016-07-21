# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit versionator toolchain-funcs eutils

MY_PV=$(get_version_component_range 1-3)
DEB_PV=$(get_version_component_range 4-5)
DESCRIPTION="create and edit the partition table of a disk partitioned in Atari format"
HOMEPAGE="http://packages.qa.debian.org/a/atari-fdisk.html"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${MY_PV}-${DEB_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# Note: The code assumes sizeof(long) == 4 everywhere.  If you try to
# use this on 64bit systems (where sizeof(long) == 8), then misbehavior
# and memory corruption will ensue.
KEYWORDS="-* m68k x86"
IUSE=""

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.7.1.5.4-prompt-logic.patch
	epatch "${FILESDIR}"/${PN}-0.7.1.5.4-gcc-5-inline.patch
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		COMPILE_ARCH=m68k
}

src_install() {
	dodoc NEWS README TODO debian/changelog
	doman debian/atari-fdisk.8

	into /
	if [[ $(tc-arch) == "m68k" ]] ; then
		dosbin fdisk
		dosym fdisk /sbin/atari-fdisk
		dosym atari-fdisk.8 /usr/share/man/man8/fdisk.8
	else
		dosbin atari-fdisk
	fi
}
