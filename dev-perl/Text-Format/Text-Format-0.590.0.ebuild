# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SHLOMIF
MODULE_VERSION=0.59

inherit perl-module

DESCRIPTION="Various subroutines to format text"

SLOT="0"
KEYWORDS="amd64 x86"

IUSE="test"

DEPEND="dev-perl/Module-Build
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do parallel"
