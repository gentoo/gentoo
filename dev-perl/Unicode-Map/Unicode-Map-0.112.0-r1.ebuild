# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-Map/Unicode-Map-0.112.0-r1.ebuild,v 1.1 2014/08/22 17:31:18 axs Exp $

EAPI=5

MODULE_AUTHOR=MSCHWARTZ
MODULE_VERSION=0.112
inherit perl-module

DESCRIPTION="Map charsets from and to utf16 code"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

SRC_TEST="do"
PATCHES=( "${FILESDIR}"/0.112-no-scripts.patch )
