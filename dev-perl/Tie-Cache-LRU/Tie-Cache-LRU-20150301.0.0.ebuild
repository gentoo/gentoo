# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MSCHWERN
MODULE_VERSION=20150301
inherit perl-module

DESCRIPTION="A Least-Recently Used cache"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/enum
	dev-perl/Carp-Assert
	dev-perl/Class-Virtual
	dev-perl/Class-Data-Inheritable"
DEPEND="${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.82 )"

SRC_TEST=do
