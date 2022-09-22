# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="PSGI handler for HTTP::Server::Simple"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-perl/HTTP-Server-Simple-0.420.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"

src_test() {
	perl_rm_files "t/release-pod-syntax.t"
	perl-module_src_test
}
