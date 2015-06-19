# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/spamcup/spamcup-1.09.ebuild,v 1.6 2014/08/10 20:46:38 slyfox Exp $

DESCRIPTION="This script does the same you would do when you report spam with your browser in Spamcop.net"
HOMEPAGE="http://sourceforge.net/projects/spamcup/"
SRC_URI="mirror://sourceforge/spamcup/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.8.0
	dev-perl/Getopt-ArgvFile
	|| ( ( >dev-perl/libwww-perl-6 dev-perl/HTML-Form ) <dev-perl/libwww-perl-6
	) "
RDEPEND="${DEPEND}"

src_install() {
	dodir /usr/bin
	dobin spamcup.pl || die "dobin failed"

	dodoc ChangeLog INSTALL
}
