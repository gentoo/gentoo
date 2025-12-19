# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KRAEHE
DIST_VERSION=0.23
inherit perl-module

DESCRIPTION="A Perl module providing a simple API to parsed XML instances"

LICENSE="GPL-2" # GPL
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/libxml-perl-0.07-r1
"
BDEPEND="${RDEPEND}
"
