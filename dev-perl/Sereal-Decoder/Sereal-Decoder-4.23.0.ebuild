# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=YVES
DIST_VERSION=4.023
inherit edo perl-module flag-o-matic

DESCRIPTION="Fast, compact, powerful binary deserialization"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-XSLoader
	app-arch/csnappy:=
	app-arch/zstd:=
	dev-libs/miniz:=
"
DEPEND="
	app-arch/csnappy:=
	app-arch/zstd:=
	dev-libs/miniz:=
"
BDEPEND="${RDEPEND}
	dev-perl/Devel-CheckLib
	>=virtual/perl-ExtUtils-MakeMaker-7.0
	>=virtual/perl-ExtUtils-ParseXS-2.210.0
	virtual/perl-File-Path
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-Deep
		dev-perl/Test-Differences
		dev-perl/Test-LongString
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Warn
	)
"

src_prepare() {
	local bundled_lib
	for bundled_lib in inc/Devel snappy miniz{.c,.h} zstd ; do
		edo rm -r ${bundled_lib}
	done

	sed -i -e "/miniz.*OBJ_EXT/d" inc/Sereal/BuildTools.pm || die

	perl-module_src_prepare
}

src_configure() {
	append-cflags "-I${ESYSROOT}/usr/include/miniz -DHAVE_MINIZ"
	append-ldflags "-L${ESYSROOT}/usr/$(get_libdir)/miniz"

	local myconf=(
		OPTIMIZE="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)

	perl-module_src_configure
}

src_compile() {
	# TODO: switch to pkg-config when bug #849578 is fixed
	DIST_MAKE=(
		"INC=-I${ESYSROOT}/usr/include/miniz"
		"OTHERLDFLAGS=-lminiz"
	)

	#DIST_MAKE=(
	#       "INC=$($(tc-getPKG_CONFIG) --cflags miniz)"
	#       "OTHERLDFLAGS=$($(tc-getPKG_CONFIG) --libs miniz)"
	#)

	perl-module_src_compile
}
