# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-SMIME/Crypt-SMIME-0.150.0.ebuild,v 1.1 2015/03/22 17:43:29 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MIKAGE
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION="S/MIME message signing, verification, encryption and decryption"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-libs/openssl:0
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/extutils-pkgconfig
	dev-perl/ExtUtils-CChecker
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
		>=dev-perl/Test-Taint-1.60.0
		dev-perl/Test-Dependencies
		>=dev-perl/Test-Pod-1.140.0
		>=dev-perl/Test-Pod-Coverage-1.40.0
	)
"

SRC_TEST=do
