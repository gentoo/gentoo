# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=LBROCARD
MODULE_VERSION=2.03
inherit perl-module eutils

DESCRIPTION="Interface to the Imlib2 image library"

SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE="test"

RDEPEND=">=media-libs/imlib2-1"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.28
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		>=media-libs/imlib2-1[jpeg,png]
	)"

SRC_TEST=do
