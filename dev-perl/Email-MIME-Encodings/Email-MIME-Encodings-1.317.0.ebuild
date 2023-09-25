# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.317
inherit perl-module

DESCRIPTION="A unified interface to MIME encoding and decoding"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-MIME-Base64-3.50.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		virtual/perl-Encode
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
