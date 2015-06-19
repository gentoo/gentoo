# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-AuthCookie/Apache-AuthCookie-3.220.0.ebuild,v 1.2 2015/06/13 17:12:16 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MSCHOUT
MODULE_VERSION=3.22
inherit perl-module

DESCRIPTION="Perl Authentication and Authorization via cookies"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=www-apache/mod_perl-2
	>=dev-perl/Apache-Test-1.35
	>=dev-perl/CGI-3.120.0
	>=dev-perl/Class-Load-0.30.0
	>=dev-perl/autobox-1.100.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
