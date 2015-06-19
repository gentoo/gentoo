# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Sync/File-Sync-0.90.0-r1.ebuild,v 1.1 2014/08/22 19:19:08 axs Exp $

EAPI=5

MODULE_AUTHOR=CEVANS
MODULE_VERSION=0.09
inherit perl-module

DESCRIPTION="Perl access to fsync() and sync() function calls"

SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"
