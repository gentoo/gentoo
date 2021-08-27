# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MONS
DIST_VERSION=0.05

inherit perl-module

DESCRIPTION="Enhancing Test::More for UTF8-based projects"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ppc ~ppc64 x86"

RDEPEND="
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PERL_RM_FILES=(
	"t/pod-coverage.t"
	"t/pod.t"
)
