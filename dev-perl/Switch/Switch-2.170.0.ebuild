# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CHORNY
MODULE_VERSION=2.17
inherit perl-module

DESCRIPTION="A switch statement for Perl"
#SRC_URI+=" http://dev.gentoo.org/~tove/distfiles/perl-core/Switch/Switch-2.16-rt60380.patch"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~amd64-linux ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~arm ~x86-fbsd"
IUSE=""

SRC_TEST="do"
#PATCHES=( "${DISTDIR}"/Switch-2.16-rt60380.patch )
