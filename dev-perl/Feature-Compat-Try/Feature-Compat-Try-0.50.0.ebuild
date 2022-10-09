# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PEVANS"
DIST_VERSION="0.05"

inherit perl-module

DESCRIPTION="Make try/catch syntax available across Perl versions"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/Syntax-Keyword-Try-0.270.0"

BDEPEND="${RDEPEND}
	dev-perl/Module-Build"
