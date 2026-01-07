# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAPATRICK
DIST_VERSION=1.24
inherit perl-module

DESCRIPTION="Creates and XML Stream connection and parses return data"

SLOT="0"
LICENSE="LGPL-2"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"

IUSE="ssl"

RDEPEND="
	dev-perl/Authen-SASL
	dev-perl/Net-DNS
	ssl? ( dev-perl/IO-Socket-SSL )
	virtual/perl-MIME-Base64
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
"
