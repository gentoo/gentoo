# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AMBS
DIST_VERSION=0.320

inherit perl-module

DESCRIPTION="Module to implement some of AutoConf macros in pure perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	dev-perl/Capture-Tiny
	virtual/perl-Carp
	virtual/perl-Exporter
	>=virtual/perl-ExtUtils-CBuilder-0.280.220
	dev-perl/File-Slurper
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	>=virtual/perl-Scalar-List-Utils-1.180.0
	virtual/perl-Text-ParseWords
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.900.0 )
"
