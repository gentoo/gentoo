# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Accessor-Grouped/Class-Accessor-Grouped-0.100.100.ebuild,v 1.2 2014/07/26 14:32:30 zlogene Exp $

EAPI=5

MODULE_AUTHOR=RIBASUSHI
MODULE_VERSION=0.10010
inherit perl-module

DESCRIPTION="Lets you build groups of accessors"

SLOT="0"
KEYWORDS="amd64 ppc x86 ~ppc-aix ~ppc-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	dev-perl/Module-Runtime
	>=dev-perl/Class-XSAccessor-1.130.0
	>=dev-perl/Sub-Name-0.50.0
"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Exception-0.310.0
		>=virtual/perl-Test-Simple-0.940.0
	)
"

SRC_TEST=do
