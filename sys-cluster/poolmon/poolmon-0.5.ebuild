# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A director mailserver pool monitoring script for Dovecot"
HOMEPAGE="https://github.com/brandond/poolmon"
SRC_URI="https://github.com/brandond/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-perl/IO-Socket-SSL
	net-mail/dovecot
	"

src_install() {
	dobin poolmon
	dodoc README
	newinitd "${FILESDIR}"/poolmon.init poolmon
	newconfd "${FILESDIR}"/poolmon.conf poolmon
	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/poolmon.logrotate poolmon
}
