# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=BIGPRESH
DIST_VERSION=1.10
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="A class for european VAT numbers validation"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/HTTP-Message-1.0.0
	>=dev-perl/libwww-perl-1.0.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	perl_rm_files t/pod{,-coverage}.t
	perl-module_src_test
}
