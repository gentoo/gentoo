# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BINGOS
DIST_VERSION=0.44
inherit perl-module

DESCRIPTION="Magical config file parser"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Config-IniFiles
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/IO-String
	virtual/perl-Text-ParseWords
	>=dev-perl/YAML-0.670.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
PERL_RM_FILES=(
	t/99_pod.t
)
