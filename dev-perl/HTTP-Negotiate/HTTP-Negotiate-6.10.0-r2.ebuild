# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GAAS
DIST_VERSION=6.01
inherit perl-module

DESCRIPTION="HTTP content negotiation"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	!<dev-perl/libwww-perl-6
	>=dev-perl/HTTP-Message-6.0.0
"
BDEPEND="${RDEPEND}
"
