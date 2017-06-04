# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SBECK
MODULE_VERSION=6.51
inherit perl-module

DESCRIPTION="Perl date manipulation routines"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"
IUSE="elibc_musl test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Encode
	virtual/perl-File-Spec
	virtual/perl-IO
	virtual/perl-Storable
	elibc_musl? ( sys-libs/timezone-data )
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.210.0
	test? (
		dev-perl/Test-Inter
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do parallel"

mydoc="HISTORY"

src_test() {
	perl_rm_files t/pod_coverage.t t/pod.t
	TZ=UTC perl-module_src_test
}
