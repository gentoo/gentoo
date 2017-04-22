# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TOMO
DIST_VERSION=0.06
DIST_SECTION=src
inherit perl-module

DESCRIPTION="SSL/STARTTLS support for Net::SMTP"
IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Authen-SASL-2.150.0
	>=dev-perl/IO-Socket-SSL-1
	>=virtual/perl-libnet-2"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"
