# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=STEVAN
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="A simple string tokenizer"

SLOT="0"
KEYWORDS="~amd64 ~x86"

src_test() {
	perl_rm_files "t/release-pod.t" "t/release-pod_coverage.t"
	perl-module_src_test
}
