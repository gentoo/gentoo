# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MooX-Types-MooseLike/MooX-Types-MooseLike-0.270.0.ebuild,v 1.3 2015/04/05 13:01:15 zlogene Exp $

EAPI=5

MODULE_AUTHOR=MATEU
MODULE_VERSION=0.27
inherit perl-module

DESCRIPTION="Some Moosish types and a type builder"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Module-Runtime-0.12.0
	>=dev-perl/Moo-0.91.10
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Set-Object
		>=dev-perl/Test-Fatal-0.3.0
		>=virtual/perl-Test-Simple-0.960.0
	)
"

SRC_TEST=do
