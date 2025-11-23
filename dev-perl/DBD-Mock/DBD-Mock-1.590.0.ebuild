# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JLCOOPER
DIST_VERSION=1.59
inherit perl-module

DESCRIPTION="Mock database driver for testing"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-perl/DBI-1.300.0"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
	test? (
		dev-perl/Test-Exception
	)
"
