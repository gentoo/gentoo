# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EHUELS
DIST_VERSION=3.12
inherit perl-module eutils

DESCRIPTION="LaTeX support for the Template Toolkit"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/LaTeX-Driver-0.70.0
	>=dev-perl/LaTeX-Encode-0.20.0
	dev-perl/LaTeX-Table
	>=dev-perl/Template-Toolkit-2.160.0
	virtual/latex-base
"
src_test() {
	LATEX_TESTING=1	perl-module_src_test
}

DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Harness )
"
