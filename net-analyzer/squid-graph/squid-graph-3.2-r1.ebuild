# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/squid-graph/squid-graph-3.2-r1.ebuild,v 1.5 2014/07/17 15:10:54 jer Exp $

EAPI=5
inherit eutils

DESCRIPTION="Squid logfile analyzer and traffic grapher"
HOMEPAGE="http://squid-graph.sourceforge.net/"
LICENSE="GPL-2"
SRC_URI="mirror://sourceforge/squid-graph/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="dev-perl/GD[png]"

S=${WORKDIR}/${PN}

src_install () {
	dobin apacheconv generate.cgi squid-graph timeconv
	dodoc README
}
