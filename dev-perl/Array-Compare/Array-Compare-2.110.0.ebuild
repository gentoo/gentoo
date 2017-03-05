# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAVECROSS
DIST_VERSION=2.11
inherit perl-module

DESCRIPTION="Perl extension for comparing arrays"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Moo
	dev-perl/Type-Tiny
"
DEPEND=">=dev-perl/Module-Build-0.40
	test? ( ${RDEPEND}
		dev-perl/Test-NoWarnings
	)
"

src_test() {
	perl_rm_files t/pod.t t/pod_coverage.t
	perl-module_src_test
}
