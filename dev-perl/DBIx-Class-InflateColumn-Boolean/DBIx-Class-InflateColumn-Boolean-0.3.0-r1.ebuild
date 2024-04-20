# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GRAF
DIST_VERSION=0.003000
inherit perl-module

DESCRIPTION="Auto-create boolean objects from columns"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/DBIx-Class-0.80.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Path-Class
		dev-perl/SQL-Translator
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=( t/pod-coverage.t t/pod.t )
