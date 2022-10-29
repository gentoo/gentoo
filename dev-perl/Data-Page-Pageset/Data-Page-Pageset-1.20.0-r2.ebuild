# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHUNZI
DIST_VERSION=1.02

inherit perl-module

DESCRIPTION="change long page list to be shorter and well navigate"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND="
	>=dev-perl/Data-Page-2.0.0
	dev-perl/Class-Accessor
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( dev-perl/Test-Exception )
"

PERL_RM_FILES=( t/pod-coverage.t t/pod.t )
