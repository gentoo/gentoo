# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MSCHILLI
DIST_VERSION=1.32
inherit perl-module

DESCRIPTION="Launch and control background processes"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test examples"

RDEPEND="virtual/perl-IO"
DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc -r eg/*
	fi
}
