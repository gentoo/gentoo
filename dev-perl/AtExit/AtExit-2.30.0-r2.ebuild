# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=2.03
inherit perl-module

DESCRIPTION="atexit() function to register exit-callbacks"

# smallest common denominator, see
# https://bugs.gentoo.org/721204
# https://rt.cpan.org/Public/Bug/Display.html?id=132447
LICENSE="Artistic"

SLOT="0"
KEYWORDS="amd64 ~ia64 ppc sparc x86"

RDEPEND="
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Capture-Tiny
		virtual/perl-Test-Simple
	)
"
