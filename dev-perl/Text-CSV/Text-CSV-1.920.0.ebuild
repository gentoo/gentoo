# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ISHIGAKI
DIST_VERSION=1.92
inherit perl-module

DESCRIPTION="Manipulate comma-separated value strings"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test +xs"

RDEPEND="
	xs? ( >=dev-perl/Text-CSV_XS-1.20.0 )
	virtual/perl-IO
"
DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/00_pod.t
	perl-module_src_test
}
