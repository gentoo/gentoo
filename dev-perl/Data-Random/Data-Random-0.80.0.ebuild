# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Random/Data-Random-0.80.0.ebuild,v 1.4 2013/05/25 07:58:34 ago Exp $

EAPI=5

MODULE_AUTHOR=BAREFOOT
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="A module used to generate random data"

SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE="test"

DEPEND="
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
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
