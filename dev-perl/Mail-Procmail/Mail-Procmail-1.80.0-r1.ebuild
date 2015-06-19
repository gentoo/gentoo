# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-Procmail/Mail-Procmail-1.80.0-r1.ebuild,v 1.1 2014/08/23 02:08:16 axs Exp $

EAPI=5

MODULE_AUTHOR=JV
MODULE_VERSION=1.08
inherit perl-module

DESCRIPTION="Mail sorting/delivery module for Perl"

SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE=""

RDEPEND="virtual/perl-Getopt-Long
	>=dev-perl/MailTools-1.15
	>=dev-perl/LockFile-Simple-0.2.5"
DEPEND="${RDEPEND}"

SRC_TEST="do"
