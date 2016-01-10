# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MIKAGE
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="S/MIME message signing, verification, encryption and decryption"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl test"

RDEPEND="
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/extutils-pkgconfig
	dev-perl/ExtUtils-CChecker
	>=virtual/perl-ExtUtils-Constant-0.230.0
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
		>=dev-perl/Test-Taint-1.60.0
		dev-perl/Test-Dependencies
		>=dev-perl/Test-Pod-1.140.0
		>=dev-perl/Test-Pod-Coverage-1.40.0
	)
"
