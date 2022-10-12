# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="EHUELS"

inherit perl-module

DESCRIPTION="PostgreSQL Database Management Facilities for PGObject"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/DBD-Pg
	dev-perl/DBI
	dev-perl/Capture-Tiny
	dev-perl/Moo"

BDEPEND="${RDEPEND}
	test? ( dev-perl/Test-Exception )"
