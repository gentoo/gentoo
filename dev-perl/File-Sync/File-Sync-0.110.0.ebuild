# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Sync/File-Sync-0.110.0.ebuild,v 1.7 2013/05/25 07:58:47 ago Exp $

EAPI=5

MODULE_AUTHOR=BRIANSKI
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="Perl access to fsync() and sync() function calls"

SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"
