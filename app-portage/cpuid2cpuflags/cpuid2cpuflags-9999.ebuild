# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/mgorny/cpuid2cpuflags"
inherit autotools git-r3

DESCRIPTION="Tool to guess CPU_FLAGS_* flags for the host"
HOMEPAGE="https://github.com/mgorny/cpuid2cpuflags"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare() {
	default
	eautoreconf
}
