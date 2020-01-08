# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RUZ
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Gumbo parser library"

SLOT="0"
KEYWORDS="~amd64"

# No tests to run
RESTRICT="test"

# Alien-Build for Alien::Base
RDEPEND="
	>=dev-perl/Alien-Build-0.5.0
	>=dev-perl/File-ShareDir-1.30.0
	>=dev-perl/Path-Class-0.13.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Alien-Base-ModuleBuild-0.5.0
	>=dev-perl/Module-Build-0.420.0
"
