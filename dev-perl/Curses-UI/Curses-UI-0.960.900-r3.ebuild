# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MDXI
DIST_VERSION=0.9609
inherit perl-module

DESCRIPTION="Perl UI framework based on the curses library"

SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Curses
	dev-perl/TermReadKey
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? ( virtual/perl-Test-Simple )
"
PATCHES=(
	"${FILESDIR}/${PN}-0.9609-no-dot-inc.patch"
)
PERL_RM_FILES=(
	t/05pod.t
)
