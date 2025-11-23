# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=VIY
DIST_VERSION=0.9524
inherit perl-module

DESCRIPTION='Perl/XS module to use HTML Templates from CGI scripts'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/libpcre2
	>=virtual/perl-File-Path-2.0.0
	virtual/perl-File-Spec
	>=dev-perl/JSON-2.0.0"
DEPEND="dev-libs/libpcre2"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_configure() {
	local myconf=(
		"PCRE2=1"
	)

	perl-module_src_configure "${myconf[@]}"
}
