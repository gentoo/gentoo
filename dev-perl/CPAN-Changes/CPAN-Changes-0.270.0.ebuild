# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BRICAS
MODULE_VERSION=0.27
inherit perl-module

DESCRIPTION='Read and write Changes files'
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="virtual/perl-Text-Tabs+Wrap
	>=virtual/perl-version-0.790.0"

DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	virtual/perl-Test-Simple"

SRC_TEST="do"
