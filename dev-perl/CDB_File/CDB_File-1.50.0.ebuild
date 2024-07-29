# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TODDR
DIST_VERSION=1.05
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Perl extension for access to cdb databases"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# bug 787551: T::Fatal and T::Warnings needed
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/B-COW
		virtual/perl-File-Temp
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
		dev-perl/Test-Warnings
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

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
