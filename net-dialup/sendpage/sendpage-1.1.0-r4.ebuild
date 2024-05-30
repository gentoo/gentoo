# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

MY_P=${PN}-1.001

DESCRIPTION="Dialup alphapaging software"
HOMEPAGE="https://sendpage.github.io/"
SRC_URI="https://www.sendpage.org/download/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="
	acct-group/sms
	acct-user/sendpage
	dev-perl/DBI
	dev-perl/Device-SerialPort
	dev-perl/MailTools
	dev-perl/Net-SNPP
	virtual/perl-libnet
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PV}-makefile.patch )

src_install() {
	perl-module_src_install
	insinto /etc
	doins sendpage.cf
	newinitd "${FILESDIR}"/sendpage.initd sendpage
	diropts -o sendpage -g sms -m0770
	keepdir /var/spool/sendpage
	docompress -x /usr/share/doc/${PF}/text/
	docinto text/
	dodoc docs/*
}
