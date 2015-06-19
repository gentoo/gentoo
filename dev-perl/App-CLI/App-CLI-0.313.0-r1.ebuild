# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/App-CLI/App-CLI-0.313.0-r1.ebuild,v 1.1 2014/08/26 17:18:59 axs Exp $

EAPI=5

MODULE_AUTHOR=CORNELIUS
MODULE_VERSION=0.313
inherit perl-module

DESCRIPTION="Dispatcher module for command line interface programs"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND=">=virtual/perl-Getopt-Long-2.35
	virtual/perl-Locale-Maketext-Simple
	virtual/perl-Pod-Simple"
DEPEND="${RDEPEND}"

SRC_TEST="do"
