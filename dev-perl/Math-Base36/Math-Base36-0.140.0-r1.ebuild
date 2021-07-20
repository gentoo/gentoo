# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BRICAS
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="Encoding and decoding of base36 strings"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	test? (
		dev-perl/Test-Exception
	)
"

PERL_RM_FILES=( t/99-pod.t t/98-pod_coverage.t )

src_prepare() {
	sed -i -e 's/use inc::Module::Install /use lib q[.];\nuse inc::Module::Install /' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
