# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMLEGGE
DIST_VERSION=0.017
inherit perl-module

DESCRIPTION="Read/write Brotli buffers/streams"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-arch/brotli:=
	dev-perl/File-Slurper
	virtual/perl-Getopt-Long
	virtual/perl-Time-HiRes
"
DEPEND="
	app-arch/brotli:=
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.017-unbundle.patch
)
