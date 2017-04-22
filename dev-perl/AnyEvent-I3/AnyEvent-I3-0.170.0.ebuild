# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MSTPLBG
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="Communicate with the i3 window manager"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	dev-perl/AnyEvent
	dev-perl/JSON-XS
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
"

src_test() {
	perl_rm_files t/manifest.t t/pod-coverage.t t/pod.t t/boilerplate.t
	perl-module_src_test
}
