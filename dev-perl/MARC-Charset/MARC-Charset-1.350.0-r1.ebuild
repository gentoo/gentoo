# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=GMCHARLT
MODULE_VERSION=1.35
inherit perl-module

DESCRIPTION="convert MARC-8 encoded strings to UTF-8"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/perl[gdbm]
	dev-perl/XML-SAX
	dev-perl/Class-Accessor
"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST=do

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
