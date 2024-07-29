# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MSTPLBG
DIST_VERSION=0.19
inherit perl-module virtualx

DESCRIPTION="Communicate with the i3 window manager"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="
	dev-perl/AnyEvent
	dev-perl/JSON-XS
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? ( x11-wm/i3 )
"

src_test() {
	perl_rm_files t/manifest.t t/pod-coverage.t t/pod.t t/boilerplate.t
	virtx perl-module_src_test
}
