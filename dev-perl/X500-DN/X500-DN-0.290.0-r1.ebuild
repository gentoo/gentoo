# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=RJOOP
MODULE_VERSION=0.29
inherit perl-module
DESCRIPTION="handle X.500 DNs (Distinguished Names), parse and format them"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ppc ~s390 sparc x86"
IUSE=""

RDEPEND="dev-perl/Parse-RecDescent"
DEPEND="${RDEPEND}"

SRC_TEST="do"
export OPTIMIZE="${CFLAGS}"
