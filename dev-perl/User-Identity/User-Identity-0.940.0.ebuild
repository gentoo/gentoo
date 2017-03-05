# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MARKOV
MODULE_VERSION=0.94
inherit perl-module

DESCRIPTION="Maintains info about a physical person"

SLOT="0"
KEYWORDS="~alpha amd64 x86"
IUSE="test"

RDEPEND="
"
#	dev-perl/TimeDate
#	dev-perl/Geography-Countries
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do

src_test() {
	perl_rm_files t/99pod.t
	perl-module_src_test
}
