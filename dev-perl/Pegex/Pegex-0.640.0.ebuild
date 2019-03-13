# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=INGY
DIST_VERSION=0.64
DIST_EXAMPLES=( "example/*" )
inherit perl-module

DESCRIPTION="Acmeist PEG Parser Framework"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ~sparc x86"
IUSE="test"

RDEPEND="
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? ( dev-perl/YAML-LibYAML )
"

src_test() {
	perl_rm_files t/author-*
	perl-module_src_test
}
