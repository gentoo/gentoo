# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module

DESCRIPTION="pgBadger is a PostgreSQL log analyzer."
HOMEPAGE="https://pgbadger.darold.net/"
SRC_URI="https://github.com/darold/pgbadger/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
		dev-perl/JSON-XS
		dev-perl/Text-CSV_XS
"
RDEPEND="${DEPEND}"

src_test() {
	prove || die
}
