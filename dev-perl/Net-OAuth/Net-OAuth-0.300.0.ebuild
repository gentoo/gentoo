# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RRWO
DIST_VERSION=0.30
inherit perl-module

DESCRIPTION="OAuth protocol support"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Class-Accessor-0.31
	>=dev-perl/Class-Data-Inheritable-0.06
	>=dev-perl/Crypt-URandom-0.370.0
	dev-perl/Digest-HMAC
	>=dev-perl/URI-5.150.0
	>=virtual/perl-Encode-2.35
	dev-perl/libwww-perl
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.423.400
	test? (
		>=virtual/perl-Test-Simple-0.66
		>=dev-perl/Test-Warn-0.21
	)
"
