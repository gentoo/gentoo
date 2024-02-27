# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=3.81
inherit perl-module

DESCRIPTION="Parse HTML documents"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-perl/HTML-Tagset
	dev-perl/HTTP-Message
	virtual/perl-IO
	dev-perl/URI
	virtual/perl-XSLoader
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
	)
"

mydoc="ANNOUNCEMENT"
