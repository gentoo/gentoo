# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=THALJEF
MODULE_VERSION=1.123
inherit perl-module

DESCRIPTION="Critique Perl source code for best-practices"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test"

RDEPEND=">=dev-perl/Module-Pluggable-3.1
	>=dev-perl/Config-Tiny-2
	>=dev-perl/Email-Address-1.88.9
	dev-perl/List-MoreUtils
	dev-perl/IO-String
	dev-perl/Perl-Tidy
	>=dev-perl/PPI-1.220
	dev-perl/PPIx-Utilities
	>=dev-perl/PPIx-Regexp-0.27.0
	dev-perl/Pod-Spell
	>=dev-perl/Set-Scalar-1.20
	dev-perl/File-HomeDir
	dev-perl/File-Which
	dev-perl/B-Keywords
	>=dev-perl/Readonly-2
	dev-perl/Exception-Class
	dev-perl/String-Format
	>=virtual/perl-version-0.77"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.402.400
	test? (
		dev-perl/Test-Deep
		dev-perl/PadWalker
		dev-perl/Test-Memory-Cycle
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

mydoc="extras/* examples/*"

SRC_TEST="do"
