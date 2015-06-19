# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-stringy/IO-stringy-2.110.0-r1.ebuild,v 1.1 2014/08/22 16:26:44 axs Exp $

EAPI=5

MODULE_AUTHOR=DSKOLL
MODULE_VERSION=2.110
inherit perl-module

DESCRIPTION="A Perl module for I/O on in-core objects like strings and arrays"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

SRC_TEST="do"
