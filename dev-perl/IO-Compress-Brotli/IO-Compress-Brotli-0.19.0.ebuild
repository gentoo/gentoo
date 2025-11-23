# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMLEGGE
DIST_VERSION=0.019
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
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.019-unbundle.patch
)
