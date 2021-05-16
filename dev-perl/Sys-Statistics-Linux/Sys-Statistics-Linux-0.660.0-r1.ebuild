# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=BLOONIX
MODULE_VERSION=0.66
inherit perl-module

DESCRIPTION="Collect linux system statistics"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/YAML-Syck"
DEPEND="
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)"

SRC_TEST="do"

src_install() {
	perl-module_src_install

	docompress -x /usr/share/doc/${PF}/examples
	docinto examples
	dodoc -r examples/.
}

src_test() {
	perl_rm_files t/001-pod.t t/002-pod-coverage.t
	perl-module_src_test
}
