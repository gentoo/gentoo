# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SVG/SVG-2.540.0.ebuild,v 1.5 2014/09/01 12:14:16 zlogene Exp $

EAPI=5

MODULE_AUTHOR=SZABGAB
MODULE_VERSION=2.54
inherit perl-module

DESCRIPTION="Perl extension for generating Scalable Vector Graphics (SVG) documents"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

RDEPEND="virtual/perl-parent"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST=do
