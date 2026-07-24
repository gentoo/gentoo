# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GTERMARS
DIST_VERSION=0.16

inherit perl-module

DESCRIPTION="XS based JavaScript minifier"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

BDEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-DiagINC-0.2.0
	)
"
