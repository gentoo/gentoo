# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ROODE
DIST_VERSION=1.16
inherit perl-module

DESCRIPTION="Easy-to-use date/time formatting"
LICENSE="Time-Format"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Date-Manip
	>=virtual/perl-Time-Local-1.70.0
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
	test? ( >=virtual/perl-Test-Simple-0.400.0 )
"

PERL_RM_FILES=( "t/0-signature.t" "SIGNATURE" )

src_configure() {
	export TZ=UTC # https://rt.cpan.org/Public/Bug/Display.html?id=85001
	perl-module_src_configure
}
