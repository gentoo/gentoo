# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MLEHMANN
DIST_VERSION=1.71
inherit perl-module toolchain-funcs

DESCRIPTION="A Perl interface to the uulib library"
# https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/Convert-UUlib#Licensing
LICENSE="BSD CC0-1.0 GPL-1 GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/common-sense-3.740.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	dev-perl/Canary-Stability
"
PATCHES=(
	"${FILESDIR}/${PN}-1.71-tc-ar.patch"
)
# system-uulib support had to be removed
# - uses 'unint.h' that no longer ships with system uulib
# - Bundled headers use different symbols not exported by system uulib
# - XS code makes use of DEFINE's no longer in system uulib headers
