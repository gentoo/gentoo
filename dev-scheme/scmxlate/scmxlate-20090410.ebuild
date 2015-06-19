# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/scmxlate/scmxlate-20090410.ebuild,v 1.3 2012/11/04 17:04:11 ulm Exp $

EAPI="3"

DESCRIPTION="Scmxlate is a configuration tool for software packages written in Scheme"
HOMEPAGE="http://www.ccs.neu.edu/home/dorai/scmxlate/scmxlate.html"
SRC_URI="http://evalwhen.com/scmxlate/scmxlate.tar.bz2
	-> ${P}.tar.bz2"

LICENSE="freedist" # license doesn't grant the right for modifications
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}"

src_compile() { true; }

src_install() {
	insinto /usr/share/${PN}/
	doins *.cl *.scm || die "doins failed"
	dodoc README || die "dodoc failed"
}
