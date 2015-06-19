# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-SMTPS/Net-SMTPS-0.30.0-r1.ebuild,v 1.1 2014/08/26 18:02:41 axs Exp $

EAPI=5

MODULE_AUTHOR=TOMO
MODULE_VERSION=0.03
MODULE_SECTION="src"

inherit perl-module

DESCRIPTION="SSL/STARTTLS support for Net::SMTP"
IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-perl/IO-Socket-SSL-1
	>=dev-perl/Authen-SASL-2.150.0
	virtual/perl-libnet"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do"
