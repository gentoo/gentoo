# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Console based hardware monitor for FreeBSD"
HOMEPAGE="ftp://ftp.freebsd.org/pub/FreeBSD/ports/local-distfiles/fenner/"
SRC_URI="ftp://ftp.freebsd.org/pub/FreeBSD/ports/local-distfiles/fenner/${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0"

KEYWORDS="~x86-fbsd"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PN}-gcc4.patch || die "patch failed"
	export CHMS="${S}/consolehm"
	# The only 'SMBus' smb.h i've found is in a different place:
	cd "${S}/consolehm"
	sed -i.orig -e 's:machine/smb.h:dev/smbus/smb.h:g' \
		configure.in \
		configure \
		chm.h  || die "sed failed."
}

src_compile() {
	cd "${S}/consolehm"
	econf || die "econf failed"
	MAKE=make emake || die "emake failed"
}

src_install() {
	dobin "${S}/consolehm/chm"
	doman "${S}/consolehm/chm.8"
	dodoc "${S}"/CHANGELOG
	dodoc "${S}"/README
	dodoc "${S}"/TODO
}
