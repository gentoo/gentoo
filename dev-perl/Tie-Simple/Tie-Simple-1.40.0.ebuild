# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=HANENKAMP
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Module for creating easier variable ties"

SLOT="0"
KEYWORDS="amd64 ~hppa ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
src_test() {
	perl_rm_files t/author-pod-{coverage,syntax}.t
	perl-module_src_test
}
