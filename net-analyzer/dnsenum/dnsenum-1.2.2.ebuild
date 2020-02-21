# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A perl script to enumerate DNS from a server"
HOMEPAGE="https://github.com/fwaeytens/dnsenum"
SRC_URI="https://dnsenum.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Net-DNS
	dev-perl/Net-IP
	dev-perl/Net-Netmask
	dev-perl/Net-Whois-IP
	dev-perl/HTML-Parser
	dev-perl/WWW-Mechanize
	dev-perl/XML-Writer"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}"/${PN}-1.2.2-remove-extension.patch )

src_install() {
	dodoc *.txt
	newbin ${PN}.pl ${PN}
}
