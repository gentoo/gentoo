# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=LDS
MODULE_VERSION=1.08
inherit perl-module

DESCRIPTION="Parse text and return a set of tokens using the same rules as the Unix shell"

SLOT="0"
KEYWORDS="~alpha amd64 ia64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

SRC_TEST="do"
