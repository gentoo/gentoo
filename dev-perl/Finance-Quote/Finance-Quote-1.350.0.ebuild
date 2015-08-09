# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ECOCODE
MODULE_VERSION=1.35
inherit perl-module

DESCRIPTION="Get stock and mutual fund quotes from various exchanges"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

# virtual/perl-Data-Dumper currently commented out in the code

RDEPEND="dev-perl/Crypt-SSLeay
	dev-perl/Date-Calc
	dev-perl/HTTP-Cookies
	dev-perl/HTTP-Message
	dev-perl/HTML-Tree
	dev-perl/HTML-TableExtract
	dev-perl/JSON
	dev-perl/Mozilla-CA
	dev-perl/libwww-perl"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod
		dev-perl/Perl-Critic-Dynamic )"

SRC_TEST="do"
