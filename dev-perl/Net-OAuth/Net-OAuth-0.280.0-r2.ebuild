# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KGRENNAN
DIST_VERSION=0.28
inherit perl-module

DESCRIPTION="OAuth protocol support"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Class-Accessor-0.31
	>=dev-perl/Class-Data-Inheritable-0.06
	dev-perl/Digest-HMAC
	dev-perl/URI
	virtual/perl-Digest-SHA
	>=virtual/perl-Encode-2.35
	dev-perl/libwww-perl
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=virtual/perl-Test-Simple-0.66
		>=dev-perl/Test-Warn-0.21
	)"
