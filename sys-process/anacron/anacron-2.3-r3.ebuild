# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="a periodic command scheduler"
HOMEPAGE="http://anacron.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

DEPEND="sys-process/cronbase"
RDEPEND="${RDEPEND}
	virtual/mta"

src_prepare() {
	epatch "${FILESDIR}"/${P}-compile-fix-from-debian.patch
	epatch "${FILESDIR}"/${P}-headers.patch
	sed -i \
		-e '/^CFLAGS/{s:=:+=:;s:-O2::}' \
		Makefile || die
}

src_configure() {
	tc-export CC
}

src_install() {
	#this does not work if the directory exists already
	diropts -m0750 -o root -g cron
	keepdir /var/spool/anacron

	doman anacrontab.5 anacron.8

	newinitd "${FILESDIR}"/anacron.rc6 anacron

	dodoc ChangeLog README TODO

	dosbin anacron

	insinto /etc
	doins "${FILESDIR}"/anacrontab
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Schedule the command \"anacron -s\" as a daily cron-job (preferably"
		elog "at some early morning hour).  This will make sure that jobs are run"
		elog "when the systems is left running for a night."
		echo
		elog "Update /etc/anacrontab to include what you want anacron to run."

		echo
		elog "You may wish to read the Gentoo Linux Cron Guide, which can be"
		elog "found online at:"
		elog "    https://wiki.gentoo.org/wiki/Cron"
	fi
}
