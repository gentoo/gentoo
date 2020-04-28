# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CDRAKE
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="pure perl IO-friendly tar file management"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-File-Temp
	virtual/perl-IO
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	"t/pod-coverage.t"
	"t/pod.t"
	"t/manifest.t"
)
