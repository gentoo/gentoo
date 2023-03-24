# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="EHUELS"

inherit perl-module

DESCRIPTION="Wrapper for raw strings mapping to BYTEA columns"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/File-Slurp
	dev-perl/DBD-Pg
	>=dev-perl/PGObject-2.0.1"

BDEPEND="${RDEPEND}"
