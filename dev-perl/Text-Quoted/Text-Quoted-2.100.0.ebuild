# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BPS
DIST_VERSION=2.10
inherit perl-module

DESCRIPTION="Extract the structure of a quoted mail message"

SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

RDEPEND="
	dev-perl/Text-Autoformat
	virtual/perl-Text-Tabs+Wrap
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
"
