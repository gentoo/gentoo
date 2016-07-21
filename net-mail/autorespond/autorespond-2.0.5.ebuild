# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Autoresponder add on package for qmailadmin"
HOMEPAGE="http://inter7.com/devel/"
SRC_URI="http://inter7.com/devel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND="virtual/qmail"
DEPEND=""

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-no-include-bounce.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install () {
	into /var/qmail
	dobin autorespond || die "dobin failed"
	into /usr
	dodoc README help_message qmail-auto #ChangeLog
	doman *.1
}

pkg_postinst() {
	ewarn "Please note that original messages are now NOT included with bounces"
	ewarn "by default. Use the flag per the help output if you want them."
}
