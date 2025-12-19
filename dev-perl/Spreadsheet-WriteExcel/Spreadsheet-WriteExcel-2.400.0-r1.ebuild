# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JMCNAMARA
DIST_VERSION=2.40
inherit perl-module

DESCRIPTION="Write cross-platform Excel binary file"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-File-Temp
	dev-perl/Parse-RecDescent
	>=dev-perl/OLE-StorageLite-0.19
	dev-perl/IO-stringy
"
BDEPEND="${RDEPEND}
"

# tests are flaky, 807247
DIST_TEST=do
