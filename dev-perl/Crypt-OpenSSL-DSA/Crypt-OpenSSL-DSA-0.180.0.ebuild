# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
DIST_AUTHOR=KMX
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION='Digital Signature Algorithm using OpenSSL'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
