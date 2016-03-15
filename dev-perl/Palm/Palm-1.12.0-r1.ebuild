# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=p5-Palm
MODULE_AUTHOR=BDFOY
MODULE_VERSION=1.012
inherit perl-module

DESCRIPTION="Perl Module for Palm Pilots"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 ppc x86"
IUSE="test"

DEPEND="
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST=do
