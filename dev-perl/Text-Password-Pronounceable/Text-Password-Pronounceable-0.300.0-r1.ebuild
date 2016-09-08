# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_VERSION=0.30
MODULE_AUTHOR=TSIBLEY
inherit perl-module

DESCRIPTION="Generate pronounceable passwords"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"

src_test() {
	perl_rm_files t/99pod.t t/99pod-coverage.t
	perl-module_src_test
}
