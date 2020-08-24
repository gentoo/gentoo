# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BINGOS
DIST_VERSION=1.92
inherit perl-module

DESCRIPTION="Patch perl source a la Devel::PPPort's buildperl.pl"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/File-pushd-1.0.0
	virtual/perl-IO
	virtual/perl-MIME-Base64
	dev-perl/Module-Pluggable
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	"t/author-pod-coverage.t"
	"t/author-pod-syntax.t"
)
