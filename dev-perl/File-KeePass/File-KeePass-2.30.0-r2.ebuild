# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RHANDOM
DIST_VERSION=2.03
inherit perl-module

DESCRIPTION="Interface to KeePass V1 and V2 database files"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-perl/Crypt-Rijndael-1
	>=virtual/perl-Digest-SHA-1
	>=virtual/perl-MIME-Base64-1
	dev-perl/XML-Parser
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
