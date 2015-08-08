# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MMIMS
MODULE_VERSION=4.01008
inherit perl-module

DESCRIPTION="A perl interface to the Twitter API"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="test"

RDEPEND="
	dev-perl/Carp-Clan
	dev-perl/Class-Load
	dev-perl/Data-Visitor
	>=dev-perl/DateTime-0.51
	dev-perl/DateTime-Format-Strptime
	>=dev-perl/Devel-StackTrace-1.21
	virtual/perl-Digest-SHA
	virtual/perl-Encode
	dev-perl/HTML-Parser
	dev-perl/HTTP-Message
	>=dev-perl/IO-Socket-SSL-2.5.0
	dev-perl/JSON
	dev-perl/LWP-Protocol-https
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Moose-0.94
	dev-perl/MooseX-Role-Parameterized
	dev-perl/Net-HTTP
	virtual/perl-libnet
	>=dev-perl/Net-OAuth-0.25
	virtual/perl-Time-HiRes
	>=dev-perl/Try-Tiny-0.03
	>=dev-perl/URI-1.40
	dev-perl/namespace-autoclean
"

DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Carp
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/libwww-perl
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
		dev-perl/Test-Warn
	)
"

# online test
SRC_TEST=skip
