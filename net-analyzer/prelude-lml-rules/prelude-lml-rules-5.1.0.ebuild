# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Prelude LML community ruleset"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="~net-analyzer/prelude-lml-${PV}"

DEPEND="${RDEPEND}"

src_install() {
	insinto "/etc/prelude-lml/ruleset"
	doins ruleset/*.rules
}
