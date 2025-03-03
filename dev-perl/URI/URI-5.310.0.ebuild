# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=5.31
inherit perl-module

DESCRIPTION="Uniform Resource Identifiers (absolute and relative)"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Encode
	>=virtual/perl-Exporter-5.570.0
	dev-perl/MIME-Base32
	>=virtual/perl-MIME-Base64-2
	>=dev-perl/Regexp-IPv6-0.30.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-libnet
	virtual/perl-parent
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Fatal
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-Test
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Warnings
	)
"
