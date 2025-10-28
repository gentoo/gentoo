# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARIOROY
DIST_VERSION=1.902
inherit perl-module

DESCRIPTION="Many-Core Engine providing parallel processing capabilities"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+sereal"

RDEPEND="
	sereal? (
		>=dev-perl/Sereal-Encoder-3.15.0
		>=dev-perl/Sereal-Decoder-3.15.0
	)
"
BDEPEND="${RDEPEND}"
