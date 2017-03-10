# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHANSEN
DIST_VERSION=0.6
inherit perl-module

DESCRIPTION="Simple Passwd authentication"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/Authen-Simple-0.300.0
	virtual/perl-IO
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"

src_test() {
	perl_rm_files "t/02pod.t" "t/03podcoverage.t"
	perl-module_src_test
}
