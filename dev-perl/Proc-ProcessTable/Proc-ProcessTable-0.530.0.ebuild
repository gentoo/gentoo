# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=JWB
DIST_VERSION=0.53
inherit perl-module

DESCRIPTION="Unix process table information"

SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="examples"

PATCHES=(
	"${FILESDIR}/amd64_canonicalize_file_name_definition.patch"
)
RDEPEND="virtual/perl-Storable"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_prepare() {
	perl-module_src_prepare
	mv "${S}"/example.pl "${S}"/contrib/ || die
	sed -i 's|^example\.pl|contrib/example.pl|' "${S}"/MANIFEST || die
}
src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc -r contrib/*
	fi
}
