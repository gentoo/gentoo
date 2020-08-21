# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=EVO
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Automated method creation module for Perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~hppa ~ia64 ~ppc s390 ~sparc ~x86 ~ppc-aix ~x86-solaris"
PATCHES=( "${FILESDIR}/${P}-perl526.patch" )
