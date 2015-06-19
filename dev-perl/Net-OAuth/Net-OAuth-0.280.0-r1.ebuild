# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-OAuth/Net-OAuth-0.280.0-r1.ebuild,v 1.2 2015/06/13 22:22:02 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=KGRENNAN
MODULE_VERSION=0.28
inherit perl-module

DESCRIPTION="OAuth protocol support"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="test"

RDEPEND="
	>=dev-perl/Class-Accessor-0.31
	>=dev-perl/Class-Data-Inheritable-0.06
	dev-perl/Digest-HMAC
	dev-perl/URI
	virtual/perl-Digest-SHA
	>=virtual/perl-Encode-2.35
	dev-perl/libwww-perl
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=virtual/perl-Test-Simple-0.66
		>=dev-perl/Test-Warn-0.21
	)"

SRC_TEST=do
