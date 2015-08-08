# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Qmail message queue tool"
HOMEPAGE="http://qmhandle.sourceforge.net/"
SRC_URI="mirror://sourceforge/qmhandle/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc sparc x86"
IUSE=""

RDEPEND="
	virtual/qmail
	dev-lang/perl
	sys-process/psmisc
"
DEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/qmHandle-gentoo-svc.patch
}

src_install() {
	dodoc README HISTORY
	dobin qmHandle || die "dobin failed"
}
