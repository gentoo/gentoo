# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DIST_AUTHOR=VIY
DIST_VERSION=0.9510
inherit perl-module

DESCRIPTION='Perl/XS module to use HTML Templates from CGI scripts'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-File-Path-2.0.0
	virtual/perl-File-Spec
	>=dev-perl/JSON-2.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-libs/libpcre
	test? ( virtual/perl-Test-Simple )
"
