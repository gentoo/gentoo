# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgbadger/pgbadger-6.4.ebuild,v 1.1 2015/04/14 08:26:46 ago Exp $

EAPI=5

inherit perl-app

DESCRIPTION="pgBadger is a PostgreSQL log analyzer"
HOMEPAGE="http://dalibo.github.io/pgbadger/"
SRC_URI="mirror://sourceforge/project/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Text-CSV_XS"
RDEPEND="${DEPEND}"
