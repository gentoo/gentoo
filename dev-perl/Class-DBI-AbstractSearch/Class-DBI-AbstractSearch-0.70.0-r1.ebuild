# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Abstract Class::DBI's SQL with SQL::Abstract::Limit"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-perl/SQL-Abstract-Limit-0.12
	dev-perl/Class-DBI"
DEPEND="${RDEPEND}"
