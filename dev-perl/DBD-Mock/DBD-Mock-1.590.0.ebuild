# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="JLCOOPER"
DIST_VERSION="1.59"

inherit perl-module

DESCRIPTION="Mock database driver for testing"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/DBI-1.643.0"

BDEPEND="${RDEPEND}
	test? ( >=dev-perl/Test-Exception-0.430.0 )
	dev-perl/Module-Build"
