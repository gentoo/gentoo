# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MINIMAL
DIST_VERSION=1.6
inherit perl-module

DESCRIPTION="Minimalistic data validation"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-perl/List-MoreUtils-0.330.0
"
BDEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
	)"

PERL_RM_FILES=("t/author-pod-syntax.t")
