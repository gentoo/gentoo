# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NEILB
DIST_VERSION=1.74
inherit perl-module

DESCRIPTION="Automatic text wrapping and reformatting"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test examples"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-perl/Text-Reform
	virtual/perl-Text-Tabs+Wrap
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
src_install() {
	perl-module_src_install
	use examples && perl_doexamples "config.emacs" "config.vim"
}
