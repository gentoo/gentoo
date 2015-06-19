# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3report/mp3report-1.0.2.ebuild,v 1.4 2014/08/10 21:08:29 slyfox Exp $

DESCRIPTION="Perl script to create an HTML report of MP3 files in a directory"
HOMEPAGE="http://mp3report.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.8.6
	dev-perl/MP3-Info"

src_install() {
	dodir /usr/share/mp3report
	insinto /usr/share/mp3report
	doins extended-template.html default-template.html
	dodoc documentation.* ChangeLog README TODO
	newbin mp3report.pl mp3report
	doman *.1
}

pkg_postinst() {
	elog "You can find templates in /usr/share/mp3report"
}
