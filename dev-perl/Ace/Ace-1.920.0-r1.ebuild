# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=AcePerl
MODULE_AUTHOR=LDS
MODULE_VERSION=1.92
inherit perl-module

DESCRIPTION="Object-Oriented Access to ACEDB Databases"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/perl-Digest-MD5
	dev-perl/Cache-Cache"
RDEPEND="${DEPEND}"

# online tests
RESTRICT=test
