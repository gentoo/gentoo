# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/scmxlate/scmxlate-20060613.ebuild,v 1.4 2014/08/10 21:25:48 slyfox Exp $

DESCRIPTION="Scmxlate is a configuration tool for software packages written in Scheme"
HOMEPAGE="http://www.ccs.neu.edu/home/dorai/scmxlate/scmxlate.html"
#http://www.ccs.neu.edu/home/dorai/scmxlate/scmxlate.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="freedist" # license doesn't grant the right for modifications
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/
	doins -r *
}
