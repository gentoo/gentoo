# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Twitter/Net-Twitter-4.000.60-r1.ebuild,v 1.2 2015/06/13 22:29:25 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MMIMS
MODULE_VERSION=4.00006
inherit perl-module

DESCRIPTION="A perl interface to the Twitter API"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE=""

RDEPEND=">=dev-perl/Moose-0.94
	dev-perl/Crypt-SSLeay
	dev-perl/Data-Visitor
	>=dev-perl/DateTime-0.51
	dev-perl/DateTime-Format-Strptime
	>=dev-perl/Devel-StackTrace-1.21
	dev-perl/Digest-HMAC
	virtual/perl-Digest-SHA
	virtual/perl-File-Spec
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	dev-perl/JSON
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Try-Tiny-0.03
	dev-perl/MooseX-Aliases
	dev-perl/MooseX-Role-Parameterized
	>=dev-perl/Net-OAuth-0.25
	dev-perl/namespace-autoclean
	>=dev-perl/URI-1.40
	dev-perl/Carp-Clan"

DEPEND="${RDEPEND}
	dev-perl/Module-Build"

# online test
SRC_TEST=skip
