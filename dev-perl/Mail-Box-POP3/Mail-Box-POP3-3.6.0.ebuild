# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=3.006
DIST_TEST="do" # parallel tests fail
inherit perl-module

DESCRIPTION="Mail::Box connector via POP3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Digest-MD5
	virtual/perl-File-Spec
	virtual/perl-IO
	>=dev-perl/Mail-Message-3
	>=dev-perl/Mail-Box-3
	virtual/perl-Scalar-List-Utils
	virtual/perl-Socket
	!!<dev-perl/Mail-Box-3
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
