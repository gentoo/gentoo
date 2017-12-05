# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EHUELS
DIST_VERSION=3.11
inherit perl-module eutils

DESCRIPTION="LaTeX support for the Template Toolkit"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="test"

RDEPEND="
	dev-perl/LaTeX-Driver
	dev-perl/LaTeX-Encode
	dev-perl/LaTeX-Table
	>=dev-perl/Template-Toolkit-2.16
	virtual/latex-base
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Harness )
"
