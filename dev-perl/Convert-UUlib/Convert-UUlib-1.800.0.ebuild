# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MLEHMANN
DIST_VERSION=1.8
inherit perl-module toolchain-funcs

DESCRIPTION="decode uu/xx/b64/mime/yenc/etc-encoded data"
# https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/Convert-UUlib#Licensing
LICENSE="BSD CC0-1.0 GPL-1 GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~m68k ppc ppc64 ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
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
