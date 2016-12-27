# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=LDS
MODULE_VERSION=1.17
inherit perl-module

DESCRIPTION="Interface to Distributed Annotation System"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/perl-IO-Compress-1.0
	sci-biology/bioperl
	>=dev-perl/HTML-Parser-3
	>=dev-perl/libwww-perl-5
	>=virtual/perl-MIME-Base64-2.12"
RDEPEND="${DEPEND}"

SRC_TEST=online
