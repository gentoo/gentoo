# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ZEV
MODULE_VERSION=0.12
inherit perl-module

DESCRIPTION="Ensure that your Makefile.PL specifies all module dependencies"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/rpm-build-perl
	dev-perl/File-Find-Rule
	virtual/perl-Module-CoreList
	dev-perl/Pod-Strip
	dev-perl/YAML
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST=do
