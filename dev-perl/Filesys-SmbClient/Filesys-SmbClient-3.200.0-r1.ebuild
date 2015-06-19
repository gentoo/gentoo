# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Filesys-SmbClient/Filesys-SmbClient-3.200.0-r1.ebuild,v 1.2 2014/12/07 13:21:39 zlogene Exp $

EAPI=5

MODULE_AUTHOR="ALIAN"
MODULE_VERSION=3.2
inherit perl-module

DESCRIPTION="Provide Perl API for libsmbclient.so"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=net-fs/samba-3.0.20[smbclient]"
RDEPEND="${DEPEND}"

# tests are not designed to work on a non-developer system.
RESTRICT=test
