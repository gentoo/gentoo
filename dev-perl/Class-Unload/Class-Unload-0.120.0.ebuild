# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ILMARI
DIST_VERSION=0.12
inherit perl-module

DESCRIPTION="Unload a class"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Class-Inspector
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Test-Requires
		dev-perl/Moose
	)
"

src_test() {
	perl_rm_files t/author-{eol,no-tabs}.t t/author-pod-{coverage,syntax}.t
	perl-module_src_test
}
