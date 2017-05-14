# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="File control configuration system and IDS"
HOMEPAGE="https://sourceforge.net/projects/filewatcher/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-perl/MailTools
	dev-vcs/rcs
	virtual/mta"

DOCS=( Changes README )

src_install() {
	keepdir /var/lib/filewatcher /var/lib/filewatcher/archive
	dosbin filewatcher
	doman filewatcher.1
	insinto /etc
	doins "${FILESDIR}"/filewatcher.conf
	einstalldocs
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
