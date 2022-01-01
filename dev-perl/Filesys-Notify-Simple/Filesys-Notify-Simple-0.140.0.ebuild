# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="Simple and dumb file system watcher"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		dev-perl/Test-SharedFork
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	t/author-pod-syntax.t
)
