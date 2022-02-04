# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CLACO
DIST_VERSION=0.04004
inherit perl-module

DESCRIPTION="Inheritable, overridable class and instance data accessor creation"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

PATCHES=( "${FILESDIR}/${PN}-0.04004-no-dot-inc.patch" )

PERL_RM_FILES=(
	t/manifest.t
	t/pod_coverage.t
	t/pod_spelling.t
	t/pod_syntax.t
	t/strict.t
	t/style_no_tabs.t
	t/warnings.t
)
