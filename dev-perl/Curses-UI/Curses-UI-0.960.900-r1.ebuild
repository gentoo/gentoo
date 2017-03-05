# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MDXI
MODULE_VERSION=0.9609
inherit perl-module

DESCRIPTION="Perl UI framework based on the curses library"

SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE="test"

RDEPEND="dev-perl/Curses
	dev-perl/TermReadKey"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"

src_prepare() {
	use test && perl_rm_files t/05pod.t
	perl-module_src_prepare
}
