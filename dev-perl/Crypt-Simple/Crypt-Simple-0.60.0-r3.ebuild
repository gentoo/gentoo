# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KASEI
DIST_VERSION=0.06
DIST_TEST="do" # concurrent io in tests
inherit perl-module

DESCRIPTION="Encrypt stuff simply"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-perl/Crypt-Blowfish-2.60.0
	>=virtual/perl-Digest-MD5-2.130.0
	>=dev-perl/FreezeThaw-0.410.0
	>=virtual/perl-IO-Compress-1.110.0
	>=virtual/perl-MIME-Base64-2.110.0
"
BDEPEND="
	${RDEPEND}
"
