# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DANIEL
MODULE_VERSION=2.4
inherit perl-module

DESCRIPTION="Access to FLAC audio metadata"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"

RDEPEND="media-libs/flac"
DEPEND="${RDEPEND}"

SRC_TEST="do"

# MI's fault
src_configure() {
	use test && perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_configure
}
