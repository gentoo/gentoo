# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DANIEL
DIST_VERSION=1.7
inherit perl-module

DESCRIPTION="Perl interface to Alec Muffett's Cracklib"

SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="sys-libs/cracklib"
DEPEND="${RDEPEND}"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.7-CFLAGS-1.patch"
	"${FILESDIR}/${PN}-1.7-no-dot-inc.patch"
)

PERL_RM_FILES=(
	t/pod-coverage.t
	t/pod.t
)
