# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=0.001003
inherit perl-module

DESCRIPTION="Write-once attributes for Moo"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Moo-1.2.0
	>=dev-perl/Class-Method-Modifiers-1.50.0
	>=dev-perl/strictures-1.0.0
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Test-Fatal
	)
"
