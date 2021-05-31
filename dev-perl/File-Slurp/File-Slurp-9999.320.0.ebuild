# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CAPOEIRAB
DIST_VERSION=9999.32
inherit perl-module

DESCRIPTION="Simple and Efficient Reading/Writing/Modifying of Complete Files"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
	>=virtual/perl-File-Spec-3.10.0
	virtual/perl-File-Temp
	virtual/perl-IO
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Scalar-List-Utils-1.0.0
		virtual/perl-Socket
		virtual/perl-Test-Simple
	)
"

mydoc="extras/slurp_article.pod"
