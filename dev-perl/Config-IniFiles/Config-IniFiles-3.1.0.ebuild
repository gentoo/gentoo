# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=3.001000
inherit perl-module

DESCRIPTION="Module for reading .ini-style configuration files"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~x86"

# needs List::Util and Scalar::Util
RDEPEND="
	dev-perl/IO-stringy
	>=virtual/perl-Scalar-List-Utils-1.330.0
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
