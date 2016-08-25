# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=AVIF
MODULE_VERSION=1.06
inherit perl-module

DESCRIPTION="Rounded or exact English expression of durations"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-linux"
IUSE="test"

DEPEND=""

src_prepare() {
	# Has to happen before configure time
	use test && perl_rm_files "t/02_pod.t" "t/03_pod_cover.t"
	perl-module_src_prepare
}

SRC_TEST=do
