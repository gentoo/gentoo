# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PHRED
DIST_VERSION=1.68
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="A wrapper that lets you read Zip archive members as if they were files"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Compress-Raw-Zlib-2.17.0
	virtual/perl-Encode
	virtual/perl-File-Path
	>=virtual/perl-File-Spec-0.800.0
	virtual/perl-File-Temp
	virtual/perl-IO
	virtual/perl-Time-Local
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		app-arch/unzip
		>=virtual/perl-Test-Simple-0.880.0
	)
"
