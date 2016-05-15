# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CHROMATIC
MODULE_VERSION=1.20120301
inherit perl-module

DESCRIPTION="Perl extension for emulating troublesome interfaces"

SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	>=dev-perl/UNIVERSAL-isa-1.201.106.140
	>=dev-perl/UNIVERSAL-can-1.201.106.170
"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Exception-0.310.0
		>=dev-perl/Test-Warn-0.230.0
		dev-perl/CGI
	)
"

SRC_TEST=do
