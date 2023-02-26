# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOMO
DIST_VERSION=0.10
DIST_SECTION=src
inherit perl-module

DESCRIPTION="SSL/STARTTLS support for Net::SMTP"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-perl/Authen-SASL-2.0.0
	>=dev-perl/IO-Socket-SSL-1.0.0
	>=virtual/perl-libnet-2.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
