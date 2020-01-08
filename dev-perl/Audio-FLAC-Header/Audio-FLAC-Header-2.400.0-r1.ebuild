# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DANIEL
MODULE_VERSION=2.4
inherit perl-module

DESCRIPTION="Access to FLAC audio metadata"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="media-libs/flac"
DEPEND="${RDEPEND}"

SRC_TEST="do"

# MI's fault
src_prepare() {
	use test && perl_rm_files t/pod.t t/pod-coverage.t
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
