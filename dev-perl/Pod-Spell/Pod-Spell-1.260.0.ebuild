# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=1.26
inherit perl-module

DESCRIPTION="A formatter for spellchecking Pod"
SRC_URI+=" mirror://gentoo/podspell.1.gz https://dev.gentoo.org/~tove/files/podspell.1.gz"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="minimal"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Tiny
	dev-perl/File-ShareDir
	dev-perl/Lingua-EN-Inflect
	virtual/perl-Pod-Escapes
	>=virtual/perl-Pod-Simple-3.270.0
	virtual/perl-Text-Tabs+Wrap
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		!minimal? ( >=virtual/perl-CPAN-Meta-2.120.900 )
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"

src_install() {
	perl-module_src_install
	doman "${WORKDIR}"/podspell.1
}
