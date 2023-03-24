# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="TOKUHIROM"
DIST_VERSION="0.10"

inherit perl-module

DESCRIPTION="Module::Build meets plugins"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Class-Method-Modifiers
	dev-perl/Data-OptList
	dev-perl/Module-Build
	dev-perl/Class-Accessor-Lite"

BDEPEND="${RDEPEND}
	test? ( dev-perl/Test-SharedFork )"
