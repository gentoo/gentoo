# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.052
inherit perl-module

DESCRIPTION="Tiny replacement for Module::Build"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="minimal"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	>=dev-perl/ExtUtils-Config-0.3.0
	>=dev-perl/ExtUtils-Helpers-0.20.0
	>=dev-perl/ExtUtils-InstallPaths-0.2.0
	>=virtual/perl-Getopt-Long-2.360.0
	>=virtual/perl-JSON-PP-2.0.0
	!minimal? ( dev-perl/CPAN-Requirements-Dynamic )
"
BDEPEND="
	${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.88
	)
"

mytargets="install"
