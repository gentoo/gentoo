# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=AJGB
DIST_VERSION=0.05
inherit perl-module flag-o-matic

DESCRIPTION="Shared secret elliptic-curve Diffie-Hellman generator"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
pkg_setup() {
	filter-flags "-flto" # https://github.com/ajgb/crypt-curve25519/issues/6
	myconf=("OPTIMIZE=${CFLAGS}")
}
