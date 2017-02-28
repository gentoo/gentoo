# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GRAF
DIST_VERSION=0.003000
inherit perl-module

DESCRIPTION="Auto-create boolean objects from columns"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-perl/DBIx-Class-0.80.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Path-Class
		dev-perl/SQL-Translator
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
