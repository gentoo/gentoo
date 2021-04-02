# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Squid logfile analyzer and traffic grapher"
HOMEPAGE="http://squid-graph.sourceforge.net/"
SRC_URI="mirror://sourceforge/squid-graph/${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-perl/GD[png]"

src_install() {
	dobin apacheconv generate.cgi squid-graph timeconv
	dodoc README
}
