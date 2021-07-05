# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=OALDERS
DIST_VERSION=6.29
inherit perl-module

DESCRIPTION="Base class for Request/Response"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

# MIME::QuotedPrint -> MIME-Base64
RDEPEND="
	!<dev-perl/libwww-perl-6
	virtual/perl-Carp
	virtual/perl-Compress-Raw-Zlib
	>=virtual/perl-Encode-3.10.0
	>=dev-perl/Encode-Locale-1.0.0
	>=virtual/perl-Exporter-5.570.0
	>=dev-perl/HTTP-Date-6.0.0
	>=virtual/perl-IO-Compress-2.21.0
	dev-perl/IO-HTML
	>=dev-perl/LWP-MediaTypes-6.0.0
	>=virtual/perl-MIME-Base64-2.100.0
	>=dev-perl/URI-1.100.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-Time-Local
		dev-perl/Try-Tiny
		dev-perl/URI
	)
"
