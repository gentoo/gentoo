# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="PSGI handler for HTTP::Server::Simple"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/HTTP-Server-Simple-0.420.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"
src_test() {
	perl_rm_files "t/release-pod-syntax.t"
	perl-module_src_test
}
