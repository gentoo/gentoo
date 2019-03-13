# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DOMIZIO
DIST_VERSION=1.5
inherit perl-module

DESCRIPTION="A selection of general-utility IO function"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_test() {
	perl_rm_files t/test_pod.t t/test_pod_coverage.t
	perl-module_src_test
}
