# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Synchronize mailboxes between a pop and an imap servers"
HOMEPAGE="http://www.linux-france.org/prj/pop2imap/"
SRC_URI="http://www.linux-france.org/prj/pop2imap/dist/${P}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 x86"

DEPEND=""
RDEPEND="dev-lang/perl
	dev-perl/Mail-POP3Client
	dev-perl/Mail-IMAPClient
	dev-perl/Email-Simple
	dev-perl/Date-Manip
	dev-perl/IO-Socket-SSL"

src_install() {
	dobin pop2imap
	dodoc ChangeLog README VERSION
}
