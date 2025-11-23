# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CWEST
DIST_VERSION=1.3
inherit perl-module

DESCRIPTION="SSL support for Net::IMAP::Simple"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-perl/IO-Socket-SSL
	dev-perl/Net-IMAP-Simple"
BDEPEND="${RDEPEND}
"
