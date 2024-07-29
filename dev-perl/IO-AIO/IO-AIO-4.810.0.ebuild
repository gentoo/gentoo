# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MLEHMANN
DIST_VERSION=4.81
DIST_WIKI="tests"
inherit perl-module

DESCRIPTION="Asynchronous Input/Output"

SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~riscv x86"

RDEPEND="
	dev-perl/common-sense
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Canary-Stability-2001
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
"

QA_CONFIG_IMPL_DECL_SKIP=(
	posix_close # not (currently) a thing
)

src_test() {
	if [[ "${IO_AIO_SANDBOX_TESTS:-0}" == 0 ]]; then
		# Tests trigger stack overflow in sandbox code, see bug #553918
		perl_rm_files t/01_stat.t t/02_read.t t/05_readdir.t t/03_errors.t
	fi
	perl-module_src_test
}
