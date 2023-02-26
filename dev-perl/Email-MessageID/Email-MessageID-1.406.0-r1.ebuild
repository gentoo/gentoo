# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.406
inherit perl-module

DESCRIPTION="Generate world unique message-ids"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 ~sparc x86 ~sparc-solaris ~x86-solaris"

RDEPEND=""
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-File-Spec
	)
"
