# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BINGOS
MODULE_VERSION=0.44
inherit perl-module

DESCRIPTION="Magical config file parser"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Config-IniFiles
	dev-perl/IO-String
	virtual/perl-Text-ParseWords
	virtual/perl-File-Spec
	>=dev-perl/YAML-0.670.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"
