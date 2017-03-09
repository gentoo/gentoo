# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CAUGUSTIN
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Pure Perl UUID Support With Functional Interface"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Digest-SHA
	virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64
	virtual/perl-Time-HiRes"
RDEPEND="${RDEPEND}"

SRC_TEST="do"
