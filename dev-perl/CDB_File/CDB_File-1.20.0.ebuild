# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TODDR
DIST_VERSION=1.02
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Tie to CDB (Bernstein's constant DB) files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/B-COW
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)
"
# Parallel breaks
DIST_TEST="do"

src_prepare() {
	mkdir "${S}/examples" || die "Can't make examples dir"
	einfo "Moving bun-x.pl to examples/"
	cp "${S}/bun-x.pl" "${S}/examples/" || die "Can't copy example to examples/"
	perl_rm_files bun-x.pl
	perl-module_src_prepare
}
