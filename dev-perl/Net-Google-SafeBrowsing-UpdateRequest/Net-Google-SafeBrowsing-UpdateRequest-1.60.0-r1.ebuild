# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DANBORN
MODULE_VERSION=1.06
inherit perl-module

DESCRIPTION="Update a Google SafeBrowsing table"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

RDEPEND="dev-perl/libwww-perl
	 >=dev-perl/Net-Google-SafeBrowsing-Blocklist-1.04"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
