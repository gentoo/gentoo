# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=GETTY
MODULE_VERSION=1.19
inherit perl-module

DESCRIPTION="HTTP Body Parser"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Digest-MD5
	>=virtual/perl-File-Temp-0.140.0
	dev-perl/libwww-perl
	>=virtual/perl-IO-1.140.0
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.860.0
	)
"

PATCHES=( "${FILESDIR}/${P}-CVE-2013-4407.patch" )

SRC_TEST=do
