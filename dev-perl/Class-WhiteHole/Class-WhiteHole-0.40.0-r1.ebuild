# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MSCHWERN
MODULE_VERSION=0.04
inherit perl-module

DESCRIPTION="base class to treat unhandled method calls as errors"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc ppc64 sparc x86 ~x86-solaris"
IUSE=""

SRC_TEST="do"
