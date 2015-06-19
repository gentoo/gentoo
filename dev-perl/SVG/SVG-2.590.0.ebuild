# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SVG/SVG-2.590.0.ebuild,v 1.4 2014/03/05 15:28:01 ago Exp $

EAPI=5

MODULE_AUTHOR=SZABGAB
MODULE_VERSION=2.59
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
