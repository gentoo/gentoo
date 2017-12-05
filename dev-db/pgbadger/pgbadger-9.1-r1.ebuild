# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module

DESCRIPTION="pgBadger is a PostgreSQL log analyzer."
HOMEPAGE="http://dalibo.github.io/pgbadger/"
SRC_URI="https://github.com/dalibo/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
		dev-perl/JSON-XS
		dev-perl/Text-CSV_XS
"
RDEPEND="${DEPEND}"
