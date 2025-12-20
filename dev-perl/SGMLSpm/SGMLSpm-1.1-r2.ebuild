# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RAAB
inherit perl-module

DESCRIPTION="Perl library for parsing the output of nsgmls"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

BDEPEND="dev-perl/Module-Build"

src_install() {
	perl-module_src_install
	dosym sgmlspl.pl /usr/bin/sgmlspl
}
