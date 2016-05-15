# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.41

inherit perl-module

DESCRIPTION="GNU C library compatible strftime for loggers and servers"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal examples"

# POSIX -> perl
RDEPEND="
	!minimal? ( dev-perl/Time-TZOffset )
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Time-Local
"

# CPAN::Meta::Prereqs -> perl-CPAN-Meta
DEPEND="
	>=dev-perl/Module-Build-0.380.0
	virtual/perl-CPAN-Meta
	${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.980.0 )
"

src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc -r eg/*
	fi
}
