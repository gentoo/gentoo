# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AKIYM
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Guess OpenSSL include path"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-File-Spec
	dev-libs/openssl:=
"
DEPEND="
	dev-libs/openssl:=
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		>=virtual/perl-Test-Simple-0.980.0
	)
"
