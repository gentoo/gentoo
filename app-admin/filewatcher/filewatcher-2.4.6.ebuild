# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="This is a configuration file control system and IDS"
HOMEPAGE="https://sourceforge.net/projects/filewatcher/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-perl/MailTools
	dev-vcs/rcs
	virtual/mta"

src_install() {
	keepdir /var/lib/filewatcher /var/lib/filewatcher/archive
	dosbin filewatcher || die "could not install filewatcher"
	doman filewatcher.1 || die "could not install filewatcher manpage"

	dodoc Changes README

	insinto /etc
	doins "${FILESDIR}"/filewatcher.conf || \
		die "could not install basic filewatcher config"
}

pkg_postinst() {
	elog " A basic configuration has been provided in"
	elog " /etc/filewatcher.conf.  It is strongly"
	elog " recommended that you invoke filewatcher via"
	elog " crontab."
	elog
	elog " 55,25,40 * * * * root /usr/sbin/filewatcher"
	elog " --config=/etc/filewatcher.conf"
}
