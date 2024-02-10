# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JV
DIST_VERSION=1.08
inherit perl-module

DESCRIPTION="Mail sorting/delivery module for Perl"

SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"

RDEPEND="
	virtual/perl-Getopt-Long
	>=dev-perl/MailTools-1.150.0
	>=dev-perl/LockFile-Simple-0.2.5
"
BDEPEND="${RDEPEND}"
