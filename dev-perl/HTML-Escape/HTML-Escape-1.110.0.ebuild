# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="TOKUHIROM"
DIST_VERSION="1.11"

inherit perl-module

DESCRIPTION="Extremely fast HTML escaping"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-perl/Module-Build-Pluggable-PPPort-0.40.0
	dev-perl/Module-Build
	test? ( dev-perl/Test-Requires )"
