# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JHI
DIST_VERSION=1.2911
inherit perl-module

DESCRIPTION="Perl module for BSD process resource limit and priority functions"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ia64 ~ppc ~ppc64 s390 ~sh sparc x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

src_test() {
	perl_rm_files t/pod{,-coverage}.t
	perl-module_src_test
}
