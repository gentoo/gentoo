# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SSIMMS
DIST_VERSION=2.027
inherit perl-module

DESCRIPTION="Facilitates the creation and modification of PDF files"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="examples"

RDEPEND="
	>=virtual/perl-IO-Compress-1.0.0
	dev-perl/Font-TTF"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	perl_rm_files "t/release-pod-syntax.t"
	perl-module_src_test
}

src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples/
		dodoc -r contrib/*
	fi
}
