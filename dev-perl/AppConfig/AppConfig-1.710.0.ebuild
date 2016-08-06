# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=NEILB
MODULE_VERSION=1.71
inherit perl-module

DESCRIPTION="Perl5 module for reading configuration files and parsing command line arguments"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~ppc-aix ~x86-fbsd ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/File-HomeDir-0.57
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do"

src_test() {
	perl_rm_files t/97-pod.t t/99_author.t
	perl-module_src_test
}
