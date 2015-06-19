# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Archive-Tar/Archive-Tar-1.920.0.ebuild,v 1.3 2015/06/04 15:54:19 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=BINGOS
MODULE_VERSION=1.92
inherit perl-module

DESCRIPTION="A Perl module for creation and manipulation of tar files"

SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND=">=virtual/perl-IO-Zlib-1.01
	virtual/perl-IO-Compress
	virtual/perl-Package-Constants"
#	dev-perl/IO-String
DEPEND="${DEPEND}
	test? ( dev-perl/Test-Pod )"

SRC_TEST="do"
