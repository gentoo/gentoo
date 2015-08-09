# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Check the status of services running on local/remote machines"
HOMEPAGE="http://www.linvision.com/checkservice/"
SRC_URI="http://www.linvision.com/checkservice/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.8
	>=dev-perl/MailTools-1.58
	>=dev-perl/File-Find-Rule-0.26
	>=virtual/perl-Getopt-Long-2.34"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e 's:/usr/local:/usr:g' $(grep -rl /usr/local *) || die "sed /usr/local"
}

src_install() {
	dodir /var/{log,lock,cache}/checkservice
	dobin checkservice || die

	insinto /usr/lib/checkservice/check
	doins plugins/check/* || die "check"
	insinto /usr/lib/checkservice/warning
	doins plugins/warning/* || die "warning"

	insinto /usr/lib/perl5/vendor_perl/CS
	doins lib/CS/* || die "perl5"

	insinto /etc/checkservice/config
	doins config/{*.mail,*.conf}
	insinto /etc/checkservice/config/plugins/warning
	doins config/plugins/warning/*

	doman man/*
	dodoc INSTALL README TODO checkservice.php cron/checkservice
}

pkg_postinst() {
	einfo "If you want a php status page or cron checkservice"
	einfo "read the INSTALL file in docs directory all files"
	einfo "and info are there"
}
