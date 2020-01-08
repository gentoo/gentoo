# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=JGMYERS
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="Encode::Detect - An Encode::Encoding subclass that detects the encoding of data"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="dev-perl/Module-Build
	virtual/perl-ExtUtils-CBuilder"

SRC_TEST=do
