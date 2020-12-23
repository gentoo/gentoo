# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TJMATHER
DIST_VERSION=1.46
inherit perl-module

DESCRIPTION="A Perl module for an DOM Level 1 compliant interface"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/libwww-perl
	>=dev-perl/XML-Parser-2.300.0
	dev-perl/XML-RegExp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/libxml-perl-0.70.0
	)
"
PATCHES=("${FILESDIR}/${PN}-1.46-nodotinc.patch")
