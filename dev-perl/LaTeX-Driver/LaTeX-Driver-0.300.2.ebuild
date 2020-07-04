# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EINHVERFR
DIST_VERSION=0.300.2
inherit perl-module

DESCRIPTION="Perl encapsulation of invoking the Latex programs"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Capture-Tiny
	dev-perl/Class-Accessor
	dev-perl/Exception-Class
	dev-perl/File-Slurp
	virtual/perl-File-Spec
	dev-perl/File-pushd
	virtual/perl-Getopt-Long
	dev-perl/Readonly
	virtual/perl-parent
	virtual/latex-base
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Exception
		app-text/texlive-core
		dev-texlive/texlive-latexextra
	)
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"

	use test && perl_rm_files t/{90-kwalitee,91-pod,92-pod-coverage,93-perl-critic}.t

	perl-module_src_prepare
}
