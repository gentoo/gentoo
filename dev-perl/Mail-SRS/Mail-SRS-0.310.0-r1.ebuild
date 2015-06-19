# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-SRS/Mail-SRS-0.310.0-r1.ebuild,v 1.1 2014/08/24 01:14:08 axs Exp $

EAPI=5

MODULE_AUTHOR=SHEVEK
MODULE_VERSION=0.31
inherit perl-module

DESCRIPTION="Interface to Sender Rewriting Scheme"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Digest-HMAC-1.01-r1
	>=dev-perl/MLDBM-2.01
	>=virtual/perl-DB_File-1.807
	>=virtual/perl-Digest-MD5-2.33
	>=virtual/perl-Storable-2.04-r1"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Pod-1.00
		>=dev-perl/Test-Pod-Coverage-0.02
	)"

SRC_TEST="do"
