# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DWHEELER
MODULE_VERSION=3.29
inherit perl-module

DESCRIPTION="Stream TAP from pgTAP test scripts"

SLOT="0"
KEYWORDS="amd64"

RDEPEND="virtual/perl-Test-Harness"
DEPEND="${RDEPEND}
		dev-perl/Module-Build
"

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
