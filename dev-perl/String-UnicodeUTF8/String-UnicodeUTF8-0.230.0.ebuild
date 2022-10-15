# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DMUEY"
DIST_VERSION="0.23"

inherit perl-module

DESCRIPTION="non-collation related unicode/utf-8 bytes string-type-agnostic utils"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-perl/Module-Build"

RDEPEND=">=dev-perl/Module-Want-0.600.0
	dev-perl/B-Flags
	dev-perl/String-Unquotemeta"
