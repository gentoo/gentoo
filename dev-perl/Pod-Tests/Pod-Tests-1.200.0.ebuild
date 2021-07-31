# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.20
inherit perl-module

DESCRIPTION="Extracts embedded tests and code examples from POD"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="virtual/perl-File-Spec
"
BDEPEND="${RDEPEND}
"
