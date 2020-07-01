# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.009
inherit perl-module

DESCRIPTION="the Eksblowfish block cipher"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Class-Mix-0.1.0
	virtual/perl-Exporter
	>=virtual/perl-MIME-Base64-2.210.0
	virtual/perl-XSLoader
	virtual/perl-parent
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	>=virtual/perl-ExtUtils-CBuilder-0.15
	test? (
		virtual/perl-Test-Simple
	)
"
src_compile() {
	./Build --config optimize="${CFLAGS}" build || die
}
