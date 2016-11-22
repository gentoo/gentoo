# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ANDYA
MODULE_VERSION=0.17
inherit perl-module

DESCRIPTION="IPC::ShareLite module for perl"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-solaris"
IUSE="test"

DEPEND="test? ( virtual/perl-Test-Simple )"
RDEPEND=""

SRC_TEST=do

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
