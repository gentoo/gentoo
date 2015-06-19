# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/libdbx/libdbx-1.0.3.ebuild,v 1.8 2015/03/21 19:36:30 jlec Exp $

EAPI=5

inherit eutils toolchain-funcs

MY_PN="libdbx"
MYFILE="${MY_PN}_${PV}.tgz"

DESCRIPTION="Tools and library for reading Outlook Express mailboxes (.dbx format)"
HOMEPAGE="http://sourceforge.net/projects/ol2mbox"
SRC_URI="mirror://sourceforge/ol2mbox/${MYFILE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

S="${WORKDIR}/${MY_PN}_${PV}"

src_prepare() {
	epatch "${FILESDIR}/bad_c.patch"
	sed -i -e 's/-g/$(CFLAGS) $(LDFLAGS)/;s|gcc|$(CC)|g' Makefile || die
	tc-export CC
}

src_install() {
	dobin readoe readdbx
	dodoc README* AUTHORS FILE-FORMAT
}
