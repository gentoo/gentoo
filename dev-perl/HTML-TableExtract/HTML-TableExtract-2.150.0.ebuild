# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MSISK
DIST_VERSION=2.15
inherit perl-module

DESCRIPTION="The Perl Table-Extract Module"

SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 x86 ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-perl/HTML-Element-Extended-1.160.0
	dev-perl/HTML-Parser
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

mydoc="TODO"
src_test() {
	# https://rt.cpan.org/Ticket/Display.html?id=121920
	perl_rm_files t/30_tree.t t/01_pod.t t/02_pod_coverage.t
	perl-module_src_test
}
