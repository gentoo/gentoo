# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIROD
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="A re-usable XPath engine for DOM-like trees"

SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86"

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}
