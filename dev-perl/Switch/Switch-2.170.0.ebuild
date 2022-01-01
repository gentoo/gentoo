# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CHORNY
MODULE_VERSION=2.17
inherit perl-module

DESCRIPTION="A switch statement for Perl"
#SRC_URI+=" https://dev.gentoo.org/~tove/distfiles/perl-core/Switch/Switch-2.16-rt60380.patch"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux"
IUSE=""

SRC_TEST="do"
#PATCHES=( "${DISTDIR}"/Switch-2.16-rt60380.patch )
