# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=BRICAS
MODULE_VERSION=0.14
inherit perl-module

DESCRIPTION="Encoding and decoding of base36 strings"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix"
IUSE="test"

DEPEND="
	test? (
		dev-perl/Test-Exception
	)
"

SRC_TEST="do"

src_test() {
	perl_rm_files t/99-pod.t t/98-pod_coverage.t
	perl-module_src_test
}
