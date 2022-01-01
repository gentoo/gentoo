# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PERIGRIN
DIST_VERSION=0.57
inherit perl-module

DESCRIPTION="SAX2 XML Writer"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Encode-2.120.0
	>=dev-perl/XML-Filter-BufferText-1.0.0
	>=dev-perl/XML-SAX-Base-1.10.0
	>=dev-perl/XML-NamespaceSupport-1.40.0
	>=dev-libs/libxml2-2.4.1"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.400.0
	)
"
