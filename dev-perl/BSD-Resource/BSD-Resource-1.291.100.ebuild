# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JHI
DIST_VERSION=1.2911
inherit perl-module

DESCRIPTION="Perl module for BSD process resource limit and priority functions"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

src_test() {
	perl_rm_files t/pod{,-coverage}.t
	perl-module_src_test
}
