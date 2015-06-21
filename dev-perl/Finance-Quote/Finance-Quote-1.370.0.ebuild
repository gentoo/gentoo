# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Finance-Quote/Finance-Quote-1.370.0.ebuild,v 1.1 2015/06/21 16:27:54 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ECOCODE
MODULE_VERSION=1.37
inherit perl-module

DESCRIPTION="Get stock and mutual fund quotes from various exchanges"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

# virtual/perl-Data-Dumper currently commented out in the code

RDEPEND="
	dev-perl/CGI
	virtual/perl-Carp
	dev-perl/DateTime
	virtual/perl-Encode
	virtual/perl-Exporter
	dev-perl/HTML-Parser
	dev-perl/HTML-TableExtract
	dev-perl/HTML-Tree
	dev-perl/HTTP-Cookies
	dev-perl/HTTP-Message
	dev-perl/JSON
	dev-perl/LWP-Protocol-https
	dev-perl/libwww-perl
	dev-perl/Mozilla-CA
	virtual/perl-Time-Piece
	dev-perl/URI
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
		dev-perl/Test-Pod
		dev-perl/Perl-Critic-Dynamic
	)
"

SRC_TEST="do parallel"
