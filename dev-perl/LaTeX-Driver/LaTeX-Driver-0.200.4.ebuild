# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=EINHVERFR
MODULE_VERSION=0.200.4
inherit perl-module

DESCRIPTION="Perl encapsulation of invoking the Latex programs"

LICENSE="|| ( GPL-1+ Artistic )"
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
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		app-text/texlive
		dev-texlive/texlive-latexextra
	)
"

SRC_TEST="do"
