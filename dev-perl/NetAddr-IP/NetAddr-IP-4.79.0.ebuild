# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIKER
DIST_VERSION=4.079
inherit perl-module

DESCRIPTION="Manipulation and operations on IP addresses"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 ~sh sparc x86"
IUSE="ipv6 test"
RESTRICT="!test? ( test )"

RDEPEND="ipv6? ( dev-perl/Socket6 )"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
PATCHES=( "${FILESDIR}/${PN}-4.079-no-sleep.patch" )
