# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=NEZUMI
DIST_VERSION=1.012
inherit perl-module

DESCRIPTION="Charset Informations for MIME"

SLOT="0"
KEYWORDS="~amd64"
IUSE="linguas_ja linguas_zh"
PATCHES=(
	"${FILESDIR}/${DIST_VERSION}-makefilepl.patch"
)
# Put JISX0213 here one day
# And POD2
RDEPEND="
	>=virtual/perl-Encode-1.980.0
	linguas_ja? ( >=dev-perl/Encode-EUCJPASCII-0.20.0 )
	linguas_zh? ( >=dev-perl/Encode-HanExtra-0.200.0  )
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
