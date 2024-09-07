# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHORNY
DIST_VERSION=0.36
inherit perl-module

DESCRIPTION="Copy file, file Copy file[s] | dir[s], dir"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc ppc64 sparc x86"

RDEPEND="
	virtual/perl-File-Spec
"
BDEPEND="${RDEPEND}
"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
