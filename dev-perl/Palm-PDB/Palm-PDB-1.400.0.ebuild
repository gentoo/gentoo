# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=CJM
DIST_VERSION=1.400

inherit perl-module

DESCRIPTION="Parse Palm database files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test examples"

# This package is split upstream from "Palm"
# so collides before 1.14.0
RDEPEND="
	!<dev-perl/Palm-1.14.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
