# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Prelude LML community ruleset"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/3.0.0/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-analyzer/prelude-lml"

RDEPEND="${DEPEND}"

src_install() {
	dodir "/etc/prelude-lml/ruleset"
	insinto "/etc/prelude-lml/ruleset"
	doins "ruleset/"*.rules
}
