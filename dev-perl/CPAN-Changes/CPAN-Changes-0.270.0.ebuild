# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CPAN-Changes/CPAN-Changes-0.270.0.ebuild,v 1.2 2014/06/28 17:25:12 zlogene Exp $

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
