# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PETDANCE
DIST_VERSION=1.08
inherit perl-module

DESCRIPTION="Tools to test taintedness"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 ~riscv ~s390 ~sparc x86"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
