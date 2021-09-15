# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=IGUTHRIE
DIST_VERSION=0.92
inherit perl-module

DESCRIPTION="Disk free based on Filesys::Statvfs"

SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
