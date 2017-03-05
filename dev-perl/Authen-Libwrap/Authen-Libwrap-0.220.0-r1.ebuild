# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DMUEY
MODULE_VERSION=0.22
inherit perl-module

DESCRIPTION="A Perl access to the TCP Wrappers interface"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="sys-apps/tcp-wrappers"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"

src_test() {
	perl_rm_files t/03_pod.t t/02_maintainer.t
	perl-module_src_test
}
