# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SARTAK
MODULE_VERSION=0.04
inherit perl-module

DESCRIPTION="Extract probable dates from strings"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Class-Data-Inheritable
	>=dev-perl/DateTime-Format-Natural-0.60
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-MockTime
	)
"

SRC_TEST="do"
