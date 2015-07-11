# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Locale-Maketext-Lexicon/Locale-Maketext-Lexicon-1.0.0.ebuild,v 1.1 2015/07/11 20:45:54 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DRTECH
MODULE_VERSION=1.00
inherit perl-module

DESCRIPTION="Use other catalog formats in Maketext"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd"
IUSE="test"

RDEPEND="
	>=virtual/perl-Locale-Maketext-1.170.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/Test-Pod
	)
"

SRC_TEST="do parallel"
