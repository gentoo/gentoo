# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="spampd is a program to scan messages for Unsolicited Commercial E-mail content"
HOMEPAGE="http://www.worlddesign.com/index.cfm/rd/mta/spampd.htm"
SRC_URI="https://github.com/mpaperno/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="acct-group/mail
	acct-user/mail
	dev-lang/perl
	dev-perl/Net-Server
	mail-filter/spamassassin
	virtual/perl-IO-Socket-IP"
DEPEND="${RDEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-no-pid-file.patch"
)

src_compile() {
	mv ${PN}.pl ${PN}
	pod2man ${PN}.pod > ${PN}.1
}

src_install() {
	dosbin ${PN}

	dodoc changelog.txt
	doman ${PN}.1

	newinitd "${FILESDIR}"/init spampd
	newconfd "${FILESDIR}"/conf spampd

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_install_serviced "${FILESDIR}/${PN}.service.conf"
}
