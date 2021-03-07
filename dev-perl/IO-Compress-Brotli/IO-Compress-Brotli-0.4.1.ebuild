# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MGV
DIST_VERSION=0.004001
inherit perl-module

DESCRIPTION="Read/write Brotli buffers/streams"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/File-Slurper
	virtual/perl-Getopt-Long
	virtual/perl-Time-HiRes
	app-arch/brotli:=
"
DEPEND="
	app-arch/brotli:=
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PATCHES=(
	"${FILESDIR}/${PN}-${DIST_VERSION}-unbundle.patch"
)
