# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

MY_P="${P}.k26"

inherit eutils toolchain-funcs

DESCRIPTION="Tool to snoop on login tty's through another tty-device or pseudo-tty"
HOMEPAGE="http://sysd.org/stas/node/35"
SRC_URI="http://sysd.org/stas/files/active/0/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS="README snooptab.dist"

src_prepare(){
	epatch "${FILESDIR}"/pinkbyte_masking.patch
	epatch "${FILESDIR}"/"${PN}"-makefile.patch
}

src_compile(){
	emake CC="$(tc-getCC)"
}

src_install() {
	dodir /var/spool/ttysnoop
	fperms o= /var/spool/ttysnoop
	dodoc ${DOCS}
	dosbin ttysnoop
	dosbin ttysnoops
	doman ttysnoop.8
	insinto /etc
	newins snooptab.dist snooptab
}
