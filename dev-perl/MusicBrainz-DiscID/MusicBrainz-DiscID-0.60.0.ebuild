# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NJH
DIST_VERSION=0.06
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Perl interface for the MusicBrainz libdiscid library"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~riscv x86"

RDEPEND=">=media-libs/libdiscid-0.2.2"
DEPEND="${RDEPEND}"
BDEPEND="
	${RDEPEND}
	virtual/pkgconfig
	test? (
		>=virtual/perl-Test-1.0.0
	)
"

PERL_RM_FILES=( t/05pod.t )

PATCHES=(
	"${FILESDIR}"/${PN}-0.60.0-perl-5.42.patch
)
