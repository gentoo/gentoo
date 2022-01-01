# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GAAS
DIST_VERSION=2.10
DIST_SECTION=GAAS
inherit perl-module

DESCRIPTION="String manipulation for Unicode strings"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~x86-linux"
IUSE=""

RDEPEND=">=virtual/perl-MIME-Base64-2.11"
DEPEND="${RDEPEND}"
