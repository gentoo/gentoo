# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Perl script to create an HTML report of MP3 files in a directory"
HOMEPAGE="http://mp3report.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/perl
	dev-perl/MP3-Info"

src_install() {
	newbin mp3report.pl mp3report

	insinto /usr/share/mp3report
	doins extended-template.html default-template.html

	dodoc documentation.* ChangeLog README TODO
	doman *.1
}

pkg_postinst() {
	elog "You can find templates in ${EROOT}/usr/share/mp3report"
}
