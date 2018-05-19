# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Prelude LML community ruleset"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="~net-analyzer/prelude-lml-${PV}"

RDEPEND="${DEPEND}"

src_install() {
	insinto "/etc/prelude-lml/ruleset"
	doins ruleset/*.rules
}
