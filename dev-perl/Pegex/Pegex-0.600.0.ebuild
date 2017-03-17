# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=INGY
MODULE_VERSION=0.60
inherit perl-module

DESCRIPTION="Acmeist PEG Parser Framework"

SLOT="0"
KEYWORDS="~alpha amd64 arm ppc ~sparc x86"
IUSE="test"

RDEPEND="
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? ( dev-perl/YAML-LibYAML )
"
