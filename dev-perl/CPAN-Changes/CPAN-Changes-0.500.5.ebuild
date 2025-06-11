# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=0.500005
inherit perl-module

DESCRIPTION="Read and write Changes files"

SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	dev-perl/Module-Runtime
	>=dev-perl/Moo-1.6.0
	>=dev-perl/Sub-Quote-1.5.0
	>=virtual/perl-Text-Tabs+Wrap-0.3.0
	dev-perl/Type-Tiny
	>=virtual/perl-version-0.990.600
"
BDEPEND="
	${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.960.0 )
"
