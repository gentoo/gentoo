# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=KGB
DIST_VERSION=1.24
inherit perl-module toolchain-funcs

DESCRIPTION="Facilitate use of FORTRAN from Perl/XS code"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-perl/File-Which
	virtual/perl-Scalar-List-Utils
	virtual/perl-Text-ParseWords
	virtual/fortran
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	# https://github.com/PDLPorters/extutils-f77/issues/10
	tc-export F77
	mkdir -p "${T}/bin" || die "Can't make ${T}/bin"
	ln -vs "$(type -p "${F77}")" "${T}/bin/gfortran" || die "Can't make gfortran symlink"
	PATH="${T}/bin:$PATH" perl-module_src_test
}
