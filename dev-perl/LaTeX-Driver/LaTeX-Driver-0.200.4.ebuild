# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EINHVERFR
DIST_VERSION=0.200.4
inherit perl-module

DESCRIPTION="Perl encapsulation of invoking the Latex programs"

SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd"
IUSE="test"

RDEPEND="
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
	virtual/perl-ExtUtils-MakeMaker
	test? (
		app-text/texlive
		dev-texlive/texlive-latexextra
	)
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
