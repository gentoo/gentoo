# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHORNY
DIST_VERSION=0.36
inherit perl-module

DESCRIPTION="Copy file, file Copy file[s] | dir[s], dir"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="virtual/perl-File-Spec"
DEPEND="${RDEPEND}"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
