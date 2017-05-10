# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DDICK
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION="Replaces actual time with simulated time"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	virtual/perl-Time-Piece
	virtual/perl-Time-Local
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}"

SRC_TEST="do parallel"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
