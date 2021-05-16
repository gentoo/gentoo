# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=KHW
MODULE_VERSION=1.25
inherit perl-module

DESCRIPTION="Unicode Normalization Forms"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
SRC_TEST="do"
