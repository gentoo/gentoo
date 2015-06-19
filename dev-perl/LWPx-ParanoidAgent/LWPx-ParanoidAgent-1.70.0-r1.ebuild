# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/LWPx-ParanoidAgent/LWPx-ParanoidAgent-1.70.0-r1.ebuild,v 1.1 2014/08/26 19:02:20 axs Exp $

EAPI=5

MODULE_AUTHOR=BRADFITZ
MODULE_VERSION=1.07
inherit perl-module

DESCRIPTION="Subclass of LWP::UserAgent that protects you from harm"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/libwww-perl
	dev-perl/Net-DNS
	virtual/perl-Time-HiRes"
RDEPEND="${DEPEND}"

SRC_TEST=no
