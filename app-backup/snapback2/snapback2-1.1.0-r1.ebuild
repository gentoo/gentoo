# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/snapback2/snapback2-1.1.0-r1.ebuild,v 1.1 2013/07/31 17:49:00 zlogene Exp $

EAPI=5

MY_PN=Snapback2
MODULE_AUTHOR=MIKEH
MODULE_VERSION=1.001
inherit perl-module

DESCRIPTION="Routines for support of rsync-based snapshot backup"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Config-ApacheFormat"

#SRC_TEST=do
