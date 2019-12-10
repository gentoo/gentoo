# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SZABGAB
MODULE_VERSION=1.115
inherit perl-module

DESCRIPTION="A Simple totally OO CGI interface that is CGI.pm compliant"

SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="dev-perl/Module-Build
	test? (
		dev-perl/libwww-perl
		dev-perl/IO-stringy
	)
"

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod.t t/manifest.t t/pod-coverage.t
	perl-module_src_test
}
