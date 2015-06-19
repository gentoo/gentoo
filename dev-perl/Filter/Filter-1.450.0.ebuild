# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Filter/Filter-1.450.0.ebuild,v 1.1 2014/07/07 18:38:50 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=RURBAN
MODULE_VERSION=1.45
inherit perl-module

DESCRIPTION="Interface for creation of Perl Filters"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

SRC_TEST=do
