# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-DBI/Apache-DBI-1.120.0-r1.ebuild,v 1.1 2014/08/23 02:35:12 axs Exp $

EAPI=5

MODULE_AUTHOR=PHRED
MODULE_VERSION=1.12
inherit perl-module

DESCRIPTION="Apache::DBI module for perl"

SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=dev-perl/Digest-SHA1-2.01
	>=virtual/perl-Digest-MD5-2.2
	>=dev-perl/DBI-1.30"
DEPEND="${RDEPEND}"

#SRC_TEST="do"
