# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CFAERBER
MODULE_VERSION=1.13
inherit perl-module

DESCRIPTION="WWW color names and equivalent RGB values"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-perl/Graphics-ColorNames-0.320.0"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-NoWarnings
	)
"

SRC_TEST="do"

src_test() {
	perl_rm_files t/10pod.t t/11pod_cover.t
	perl-module_src_test
}
