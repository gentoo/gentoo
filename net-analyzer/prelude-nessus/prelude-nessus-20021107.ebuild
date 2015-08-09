# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Nessus Correlation support for Prelude-IDS"
HOMEPAGE="http://www.rstack.org/oudot/prelude/correlation/"

MY_P="${P/nessus/correlation}"

SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="dev-lang/perl"

S=${WORKDIR}/${MY_P}

src_install() {
	dobin *.pl
	dodoc CORRELATION_README EXAMPLES NEWS vuln.conf_example
}
