# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=FLORA
DIST_VERSION=1.2
inherit perl-module

DESCRIPTION="Set up a CGI environment from an HTTP::Request"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Accessor
	>=dev-perl/HTTP-Message-1.530.0
	virtual/perl-IO
	dev-perl/URI
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	perl_rm_files "t/release-pod-syntax.t" "t/release-pod-coverage.t"
	perl-module_src_test
}
src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc -r examples
	fi
}
