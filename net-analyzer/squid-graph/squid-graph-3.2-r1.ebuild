# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="Squid logfile analyzer and traffic grapher"
HOMEPAGE="http://squid-graph.sourceforge.net/"
LICENSE="GPL-2"
SRC_URI="mirror://sourceforge/squid-graph/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-perl/GD[png]"

S=${WORKDIR}/${PN}

src_install () {
	dobin apacheconv generate.cgi squid-graph timeconv
	dodoc README
}
