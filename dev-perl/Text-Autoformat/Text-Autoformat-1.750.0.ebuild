# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=1.75
inherit perl-module

DESCRIPTION="Automatic text wrapping and reformatting"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="examples"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-perl/Text-Reform
	virtual/perl-Text-Tabs+Wrap
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"

src_install() {
	perl-module_src_install
	use examples && perl_doexamples "config.emacs" "config.vim"
}
