# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/JSON-XS/JSON-XS-2.340.0-r1.ebuild,v 1.1 2014/08/23 00:14:24 axs Exp $

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=2.34
inherit perl-module

DESCRIPTION="JSON::XS - JSON serialising/deserialising, done correctly and fast"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~x64-macos ~x86-solaris"
IUSE="test"

RDEPEND="dev-perl/common-sense"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Harness )"

SRC_TEST="do"
