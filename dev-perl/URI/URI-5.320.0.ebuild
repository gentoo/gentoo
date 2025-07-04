# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=5.32
inherit perl-module

DESCRIPTION="Uniform Resource Identifiers (absolute and relative)"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	dev-perl/MIME-Base32
	>=virtual/perl-MIME-Base64-2
	>=dev-perl/Regexp-IPv6-0.30.0
"
DEPEND="
	${RDEPEND}
	test? (
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Warnings
	)
"
