# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MSCHOUT
DIST_VERSION=1.47
inherit perl-module

DESCRIPTION="Expand template text with embedded Perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~x86 ~ppc-macos"
IUSE=""

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	perl_rm_files t/author-*.t
	perl-module_src_test
}
