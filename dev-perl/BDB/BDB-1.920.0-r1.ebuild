# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MLEHMANN
DIST_VERSION=1.92
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Asynchronous Berkeley DB access"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/common-sense
	sys-libs/db:=
"
DEPEND="
	sys-libs/db:=
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
