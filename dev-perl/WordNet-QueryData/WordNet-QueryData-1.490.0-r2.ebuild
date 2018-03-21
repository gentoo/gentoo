# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JRENNIE
DIST_VERSION=1.49
inherit perl-module

DESCRIPTION="Direct perl interface to WordNet database"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-dicts/wordnet"
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}/${PN}-1.49-paths.patch"
	"${FILESDIR}/${PN}-1.49-test-counts.patch"
	"${FILESDIR}/${PN}-1.49-harness.patch"
)
