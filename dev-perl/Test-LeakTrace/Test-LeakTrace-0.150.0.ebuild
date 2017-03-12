# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=GFUJI
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION='Traces memory leaks'

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

SRC_TEST="do"
