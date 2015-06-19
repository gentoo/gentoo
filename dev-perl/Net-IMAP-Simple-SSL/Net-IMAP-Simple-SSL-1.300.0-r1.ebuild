# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-IMAP-Simple-SSL/Net-IMAP-Simple-SSL-1.300.0-r1.ebuild,v 1.1 2014/08/26 18:50:14 axs Exp $

EAPI=5

MODULE_AUTHOR=CWEST
MODULE_VERSION=1.3
inherit perl-module

DESCRIPTION="SSL support for Net::IMAP::Simple"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/IO-Socket-SSL
	dev-perl/Net-IMAP-Simple"
DEPEND="${RDEPEND}"

SRC_TEST="do"
