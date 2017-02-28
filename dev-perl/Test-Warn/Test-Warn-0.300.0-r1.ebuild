# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CHORNY
MODULE_VERSION=0.30
inherit perl-module

DESCRIPTION="Perl extension to test methods for warnings"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"

IUSE="test"

RDEPEND="
	>=virtual/perl-Carp-1.220.0
	>=dev-perl/Sub-Uplevel-0.12
	>=virtual/perl-Test-Simple-0.880.0
"
DEPEND="${RDEPEND}
	test? (
		virtual/perl-File-Spec
	)
"

SRC_TEST="do"
