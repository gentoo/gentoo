# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.71
inherit perl-module

DESCRIPTION="Memory mapping made simple and safe"

SLOT="0"
KEYWORDS="~amd64 arm ~ppc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-perl/Sub-Exporter-Progressive-0.1.5
	virtual/perl-XSLoader
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-IO
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
		>=dev-perl/Test-Warnings-0.5.0
		virtual/perl-Time-HiRes
	)
"

src_compile() {
	./Build --config "optimize=${CFLAGS}" build || die
}
