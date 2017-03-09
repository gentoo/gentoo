# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CFAERBER
DIST_VERSION=1.074
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Simple calculations with RGB colors"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test minimal"

RDEPEND=">=dev-perl/Graphics-ColorNames-2.100.0
	>=dev-perl/Graphics-ColorNames-WWW-0.10.0
	!minimal? ( >=dev-perl/Graphics-ColorObject-0.5.0 )
	>=dev-perl/Params-Validate-0.750.0"

DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-NoWarnings
	)"

src_test() {
	perl_rm_files t/10pod.t t/11pod_cover.t
	perl-module_src_test
}
