# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BHALLISSY
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="module for compiling and altering fonts"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="
	virtual/perl-IO-Compress
	dev-perl/IO-String
	dev-perl/XML-Parser
"
DEPEND="${RDEPEND}"

src_test() {
	perl_rm_files t/changes.t
	perl-module_src_test
}
