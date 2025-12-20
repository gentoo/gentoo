# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AUFFLICK

inherit perl-module

DESCRIPTION="A simple http server class with SSL support"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="test"

RDEPEND="
	dev-perl/IO-Socket-INET6
	dev-perl/IO-Socket-SSL
"

DEPEND="${RDEPEND}"
BDEPEND="
	${RDEPEND}
	test? ( dev-perl/HTTP-Daemon )
"
