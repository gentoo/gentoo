# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=OALDERS
DIST_VERSION=6.03
inherit perl-module

DESCRIPTION="Storage of cookies"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	!<dev-perl/libwww-perl-6
	virtual/perl-Carp
	>=dev-perl/HTTP-Date-6.0.0
	virtual/perl-Time-Local
	>=dev-perl/HTTP-Message-6.0.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test
		virtual/perl-Test-Simple
		dev-perl/URI
	)
"
src_test() {
	perl_rm_files t/author-*.t t/release-*.t
	perl-module_src_test
}
