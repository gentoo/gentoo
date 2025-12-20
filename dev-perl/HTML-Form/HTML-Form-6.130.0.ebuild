# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=6.13
inherit perl-module

DESCRIPTION="Class that represents an HTML form element"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"

RDEPEND="
	!<dev-perl/libwww-perl-6
	dev-perl/HTML-Parser
	>=dev-perl/HTTP-Message-7.10.0
	>=dev-perl/URI-1.100.0
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Test-Warnings
	)
"
