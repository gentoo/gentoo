# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-OpenSSL-DSA/Crypt-OpenSSL-DSA-0.150.0.ebuild,v 1.1 2015/03/17 14:53:15 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=KMX
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION='Digital Signature Algorithm using OpenSSL'
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/openssl:0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"
