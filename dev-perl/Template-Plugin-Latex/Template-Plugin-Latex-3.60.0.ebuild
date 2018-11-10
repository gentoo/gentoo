# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=EINHVERFR
MODULE_VERSION=3.06
inherit perl-module eutils

DESCRIPTION="LaTeX support for the Template Toolkit"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd"
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

SRC_TEST="do"
