# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="a periodic command scheduler"
HOMEPAGE="http://anacron.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE=""

DEPEND=">=sys-apps/sed-4
	sys-process/cronbase"
RDEPEND="virtual/mta
	virtual/cron"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-compile-fix-from-debian.patch
	sed -i "s:^CFLAGS =:CFLAGS = $CFLAGS:" Makefile
}

src_compile() {
	emake || die
}

src_install() {
	#this does not work if the directory exists already
	diropts -m0750 -o root -g cron
	keepdir /var/spool/anacron

	doman anacrontab.5 anacron.8

	newinitd "${FILESDIR}"/anacron.rc6 anacron

	dodoc ChangeLog README TODO

	insinto /usr/sbin
	insopts -o root -g root -m 0750 ; doins anacron

	insinto /etc
	doins "${FILESDIR}"/anacrontab
}

pkg_postinst() {
	einfo "Schedule the command \"anacron -s\" as a daily cron-job (preferably"
	einfo "at some early morning hour).  This will make sure that jobs are run"
	einfo "when the systems is left running for a night."
	einfo ""
	einfo "Update /etc/anacrontab to include what you want anacron to run."

	echo
	einfo "You may wish to read the Gentoo Linux Cron Guide, which can be"
	einfo "found online at:"
	einfo "    https://www.gentoo.org/doc/en/cron-guide.xml"
	echo
}
