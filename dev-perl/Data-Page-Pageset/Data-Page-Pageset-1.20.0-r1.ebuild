# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="CHUNZI"
DIST_VERSION="1.02"

inherit perl-module

DESCRIPTION="change long page list to be shorter and well navigate"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Data-Page-2.0.0
	dev-perl/Class-Accessor
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( dev-perl/Test-Exception )
"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
