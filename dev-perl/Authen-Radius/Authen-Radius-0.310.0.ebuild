# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PORTAONE
DIST_VERSION=0.31
DIST_EXAMPLES=("contrib/*")
inherit perl-module

DESCRIPTION="Communicate with a Radius server from Perl"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Data-Dumper-1.0.0
	>=dev-perl/Data-HexDump-0.20.0
	>=virtual/perl-Digest-MD5-2.200.0
	>=virtual/perl-IO-1.120.0
	>=dev-perl/Net-IP-1.260.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		dev-perl/Test-NoWarnings
		virtual/perl-Test-Simple
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.26-cisco-dictionary.patch
	"${FILESDIR}"/${PN}-0.26-no-install-db.patch
)

src_configure() {
	export OPTIMIZE="$CFLAGS"
	perl-module_src_configure
}

src_install() {
	perl-module_src_install

	# Really want to install these radius dictionaries?
	insinto /etc/raddb
	doins raddb/dictionary*
}
