# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Date-Extract/Date-Extract-0.40.0.ebuild,v 1.1 2014/05/28 12:22:11 zlogene Exp $

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
