# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JONASBN
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="test module to test/assert response times"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Error
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.300.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Exception
	)
"
src_test() {
	perl_rm_files t/author-* t/release-*
	perl-module_src_test
}
