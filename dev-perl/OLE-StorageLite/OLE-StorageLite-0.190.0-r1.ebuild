# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/OLE-StorageLite/OLE-StorageLite-0.190.0-r1.ebuild,v 1.1 2014/08/22 16:47:46 axs Exp $

EAPI=5

MY_PN=OLE-Storage_Lite
MODULE_AUTHOR=JMCNAMARA
MODULE_VERSION=0.19
inherit perl-module

DESCRIPTION="Simple Class for OLE document interface"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

SRC_TEST="do"
