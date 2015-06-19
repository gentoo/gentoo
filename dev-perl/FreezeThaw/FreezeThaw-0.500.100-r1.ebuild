# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/FreezeThaw/FreezeThaw-0.500.100-r1.ebuild,v 1.5 2014/08/26 10:12:41 kumba Exp $

EAPI=5

MODULE_AUTHOR=ILYAZ
MODULE_SECTION=modules
MODULE_VERSION=0.5001
inherit perl-module

DESCRIPTION="converting Perl structures to strings and back"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

SRC_TEST=do
