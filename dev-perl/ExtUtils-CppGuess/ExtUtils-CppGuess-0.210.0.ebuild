# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETJ
DIST_VERSION=0.21
inherit perl-module toolchain-funcs

DESCRIPTION="Guess C++ compiler and flags"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Capture-Tiny
	>=virtual/perl-ExtUtils-ParseXS-3.350.0
	virtual/perl-File-Spec
	virtual/perl-File-Temp
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Path
		virtual/perl-Data-Dumper
		>=virtual/perl-ExtUtils-CBuilder-0.280.231
		virtual/perl-ExtUtils-Manifest
		dev-perl/Module-Build
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-autodie
	)
"
src_test() {
	# https://github.com/tsee/extutils-cppguess/issues/23
	tc-export CXX
	mkdir -p "${T}/bin" || die "Cant make dir ${T}/bin"
	einfo "CXX: ${CXX}"
	ln -vs "${EPREFIX}/usr/bin/${CXX}" "${T}/bin/g++" || die "Can't make symlink ${T}/bin/g++"
	PATH="${T}/bin:${PATH}" perl-module_src_test
}
