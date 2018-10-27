# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAPATRICK
DIST_VERSION=1.24
inherit perl-module

DESCRIPTION="Creates and XML Stream connection and parses return data"

SLOT="0"
LICENSE="LGPL-2"

KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="ssl"

RDEPEND="dev-perl/Authen-SASL
	dev-perl/Net-DNS
	ssl? ( dev-perl/IO-Socket-SSL )
	virtual/perl-MIME-Base64"
DEPEND="dev-perl/Module-Build"
