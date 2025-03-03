# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GUIDO
DIST_VERSION=1.35
DIST_EXAMPLES=("sample/*")
inherit perl-module

DESCRIPTION="High-Level Interface to Uniforum Message Translation"
HOMEPAGE="http://guido-flohr.net/projects/libintl-perl https://metacpan.org/release/libintl-perl"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="minimal"

RDEPEND="
	virtual/libintl
	!minimal? (
		dev-perl/File-ShareDir
	)
	virtual/perl-File-Spec
	>=virtual/perl-version-0.770.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=( "${FILESDIR}/${PN}-1.280.0-sanity-2.patch" )
