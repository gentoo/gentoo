# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=RHANDOM
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION="Runtime enable taint checking"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sparc x86 ~amd64-fbsd"
IUSE=""

SRC_TEST=do
