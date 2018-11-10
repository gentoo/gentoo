# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_VERSION=1.3
MODULE_AUTHOR=DANIEL
inherit perl-module

DESCRIPTION="extension for reading WMA/ASF metadata"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND=""

SRC_TEST=do

src_prepare() {
	# MI things
	use test && perl_rm_files t/pod.t t/pod-coverage.t
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
