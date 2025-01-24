# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=6.46
inherit perl-module

DESCRIPTION="Base class for Request/Response"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	!<dev-perl/libwww-perl-6
	virtual/perl-Carp
	>=dev-perl/Clone-0.460.0
	virtual/perl-Compress-Raw-Bzip2
	>=virtual/perl-Compress-Raw-Zlib-2.62.0
	>=virtual/perl-Encode-3.10.0
	>=dev-perl/Encode-Locale-1.0.0
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-File-Spec
	>=dev-perl/HTTP-Date-6.0.0
	>=virtual/perl-IO-Compress-2.21.0
	dev-perl/IO-HTML
	>=dev-perl/LWP-MediaTypes-6.0.0
	>=virtual/perl-MIME-Base64-2.100.0
	>=dev-perl/URI-1.100.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Needs
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-Time-Local
		dev-perl/Try-Tiny
		dev-perl/URI
	)
"
