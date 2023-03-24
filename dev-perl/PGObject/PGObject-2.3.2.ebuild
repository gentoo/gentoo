# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="EHUELS"

inherit perl-module

DESCRIPTION="A toolkit integrating intelligent PostgreSQL dbs into Perl objects"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Try-Tiny
	dev-perl/DBD-Pg"

BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Exception
	)"
