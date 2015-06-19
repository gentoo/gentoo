# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTTP-BrowserDetect/HTTP-BrowserDetect-1.770.0.ebuild,v 1.4 2015/06/13 22:51:27 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=OALDERS
MODULE_VERSION=1.77
inherit perl-module

DESCRIPTION="Determine Web browser, version, and platform from an HTTP user agent string"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~x86"
IUSE="test"

RDEPEND=""
DEPEND="
	>=dev-perl/Module-Build-0.280.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-JSON-PP
		dev-perl/Path-Tiny
		dev-perl/Test-FailWarnings
		virtual/perl-Test-Simple
		dev-perl/Test-Most
		dev-perl/Test-NoWarnings
	)
"

SRC_TEST="do"
