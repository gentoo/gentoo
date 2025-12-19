# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TJMATHER
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Regular expressions for XML tokens"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/XML-Parser-2.290.0
"
BDEPEND="${RDEPEND}
"
