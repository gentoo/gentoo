# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DMUEY"
DIST_VERSION="0.34"

inherit perl-module

DESCRIPTION="Methods for getting localized CLDR language/territory names"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/String-UnicodeUTF8
	dev-perl/File-Slurp
	>=dev-perl/Module-Want-0.600"

BDEPEND="test? (
	${RDEPEND}
	dev-perl/Test-Carp
)"
