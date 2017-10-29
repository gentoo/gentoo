# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MDXI
DIST_VERSION=0.9609
inherit perl-module

DESCRIPTION="Perl UI framework based on the curses library"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Curses
	dev-perl/TermReadKey"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

src_prepare() {
	use test && perl_rm_files t/05pod.t
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
