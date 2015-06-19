# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Filesys-DiskSpace/Filesys-DiskSpace-0.50.0-r1.ebuild,v 1.1 2014/08/22 19:19:54 axs Exp $

EAPI=5

MODULE_AUTHOR=FTASSIN
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Perl df"

SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

#Disabled - assumes you have ext2 mounts actively mounted!?!
#SRC_TEST="do"
