# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A perl script to enumerate DNS from a server"
HOMEPAGE="https://github.com/SparrowOchon/dnsenum2"
SRC_URI="https://github.com/SparrowOchon/dnsenum2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/HTML-Parser
	dev-perl/Net-DNS
	dev-perl/Net-IP
	dev-perl/Net-Netmask
	dev-perl/Net-Whois-IP
	dev-perl/String-Random
	dev-perl/WWW-Mechanize
	dev-perl/XML-Writer"

S="${WORKDIR}/${PN}2-${PV}"

src_prepare() {
	default
	sed -i -e "s:dnsenum\.pl:dnsenum:g" dnsenum.pl || die
}

src_install() {
	emake DESTDIR="${D}" INSTALL_DEPS=0 install
	dodoc README.md
}
