# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=1.75
inherit perl-module

DESCRIPTION="Automatic text wrapping and reformatting"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
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
