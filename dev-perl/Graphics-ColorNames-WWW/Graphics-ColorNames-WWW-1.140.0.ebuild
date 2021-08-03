# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CFAERBER
DIST_VERSION=1.14
inherit perl-module

DESCRIPTION="WWW color names and equivalent RGB values"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Graphics-ColorNames-0.320.0
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-NoWarnings
	)
"

src_test() {
	perl_rm_files t/10pod.t t/11pod_cover.t
	perl-module_src_test
}
