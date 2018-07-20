# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="KRYDE"
DIST_VERSION="6"
inherit perl-module

DESCRIPTION="constant subs with deferred value calculation"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="test examples"

RDEPEND="virtual/perl-Carp"
DEPEND="virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Exporter
	test? ( virtual/perl-Data-Dumper
		virtual/perl-Test
		virtual/perl-Test-Simple )"

src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
