# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BAREFOOT
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="A module used to generate random data"

SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE="test"

DEPEND="
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"

src_prepare() {
	sed -i '/jsonmeta;/d' Makefile.PL || die
	sed -i \
		-e '/^Data-Random-0.07_001.tar.gz/d' \
		-e '/^META.yml/d' \
		MANIFEST || die

	perl-module_src_prepare
}

src_test() {
	perl_rm_files t/z0_pod.t t/z1_pod-coverage.t
	perl-module_src_test
}
