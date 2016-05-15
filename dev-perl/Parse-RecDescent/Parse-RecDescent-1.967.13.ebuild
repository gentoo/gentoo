# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=JTBRAUN
DIST_VERSION=1.967013
inherit perl-module

DESCRIPTION="Generate Recursive-Descent Parsers"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test examples"

RDEPEND="
	>=virtual/perl-Text-Balanced-1.950.0
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-Warn
	)
"
src_test() {
	perl_rm_files "t/pod.t"
	perl-module_src_test
}
src_install() {
	perl-module_src_install
	docinto html/
	dodoc -r tutorial
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples/
		docinto examples/
		dodoc -r demo/*
	fi
}
