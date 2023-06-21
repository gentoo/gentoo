# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JBERGER
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Tied array which combines the power of Tie::File and Text::CSV"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Scalar-List-Utils
	dev-perl/Text-CSV
"
BDEPEND=">=dev-perl/Module-Build-0.360.100"
