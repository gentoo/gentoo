# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CAUGUSTIN
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Pure Perl UUID Support With Functional Interface"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="virtual/perl-Digest-SHA
	virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64
	virtual/perl-Time-HiRes"
BDEPEND="${RDEPEND}
"
