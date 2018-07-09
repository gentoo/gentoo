# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MLEHMANN
DIST_VERSION=4.34
inherit perl-module

DESCRIPTION="Asynchronous Input/Output"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
#RESTRICT="test"

RDEPEND="dev-perl/common-sense"
DEPEND="${RDEPEND}
	>=dev-perl/Canary-Stability-2001
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
"
src_test() {
	if [[ "${IO_AIO_SANDBOX_TESTS:-0}" == 0 ]]; then
		# Tests trigger stack overflow in sandbox code, see bug 553918
		perl_rm_files t/01_stat.t t/02_read.t t/05_readdir.t t/03_errors.t
		ewarn "Some tests cannot be run under a sandbox. For details, see:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	fi
	perl-module_src_test
}
