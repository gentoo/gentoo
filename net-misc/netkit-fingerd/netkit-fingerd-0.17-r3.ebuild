# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

MY_PN="${PN/netkit/bsd}"
MY_PN="${MY_PN/rd/r}"
DESCRIPTION="Netkit - fingerd and finger client"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
SRC_URI="mirror://debian/pool/main/b/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-r2-gentoo.diff
	epatch "${FILESDIR}"/${P}-name-check.patch #80286
}

src_configure() {
	# We'll skip this stage as the configure script is crappy and not really
	# needed -- src_install installs all files by hand.
	touch MCONFIG
	tc-export CC
}

src_compile() {
	emake CC="${CC}"
}

src_install() {
	dobin finger/finger
	dosbin fingerd/fingerd
	dosym fingerd /usr/sbin/in.fingerd
	doman finger/finger.1 fingerd/fingerd.8
	dosym fingerd.8 /usr/share/man/man8/in.fingerd.8
	dodoc README ChangeLog BUGS

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/fingerd.xinetd fingerd
}
