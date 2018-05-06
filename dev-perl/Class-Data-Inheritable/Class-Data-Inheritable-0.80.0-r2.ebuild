# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TMTM
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Inheritable, overridable class data"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

export OPTIMIZE="${CFLAGS}"

src_test() {
	perl_rm_files t/pod{,-coverage}.t
	perl-module_src_test
}
