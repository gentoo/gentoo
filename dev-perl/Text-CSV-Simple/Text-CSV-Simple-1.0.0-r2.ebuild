# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TMTM
DIST_VERSION=1.00
inherit perl-module

DESCRIPTION="Text::CSV::Simple - Simpler parsing of CSV files"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="amd64 ~arm ~mips ~x86"

RDEPEND="
	dev-perl/Text-CSV_XS
	dev-perl/Class-Trigger
	dev-perl/File-Slurp
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"
