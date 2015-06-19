# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-NYTProf/Devel-NYTProf-5.60.0.ebuild,v 1.1 2014/10/10 16:43:30 zlogene Exp $

EAPI=5

MODULE_AUTHOR=TIMB
MODULE_VERSION=5.06
inherit perl-module

DESCRIPTION="Powerful feature-rich perl source code profiler"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Getopt-Long
	dev-perl/JSON-Any
	sys-libs/zlib
"
#	virtual/perl-XSLoader
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Scalar-List-Utils
		>=virtual/perl-Test-Simple-0.84
		dev-perl/Test-Differences
	)
"
SRC_TEST="do"
