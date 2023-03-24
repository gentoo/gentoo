# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="TOKUHIROM"
DIST_VERSION="0.04"

inherit perl-module

DESCRIPTION="Generate ppport.h"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Class-Accessor-Lite
	dev-perl/Module-Build
	>=dev-perl/Module-Build-Pluggable-0.100.0"

BDEPEND="test? (
	${RDEPEND}
	dev-perl/Test-Requires
)"
