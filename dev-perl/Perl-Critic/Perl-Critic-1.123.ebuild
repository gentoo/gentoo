# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Perl-Critic/Perl-Critic-1.123.ebuild,v 1.3 2015/06/13 21:57:34 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=THALJEF
MODULE_VERSION=1.123
inherit perl-module

DESCRIPTION="Critique Perl source code for best-practices"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test"

RDEPEND=">=dev-perl/Module-Pluggable-3.1
	>=dev-perl/Config-Tiny-2
	>=dev-perl/Email-Address-1.88.9
	dev-perl/List-MoreUtils
	dev-perl/IO-String
	dev-perl/perltidy
	>=dev-perl/PPI-1.220
	dev-perl/PPIx-Utilities
	>=dev-perl/PPIx-Regexp-0.27.0
	dev-perl/Pod-Spell
	>=dev-perl/set-scalar-1.20
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
