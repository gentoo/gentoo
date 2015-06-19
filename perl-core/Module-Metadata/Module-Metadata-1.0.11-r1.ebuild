# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Module-Metadata/Module-Metadata-1.0.11-r1.ebuild,v 1.2 2015/06/08 20:15:59 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=APEIRON
MODULE_VERSION=1.000011
inherit perl-module

DESCRIPTION="Gather package and POD information from perl module files"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=virtual/perl-version-0.870"
DEPEND="${RDEPEND}"

SRC_TEST="do"
