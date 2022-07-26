# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool to guess CPU_FLAGS_* flags for the host"
HOMEPAGE="https://github.com/mgorny/cpuid2cpuflags/"
SRC_URI="
	https://github.com/mgorny/cpuid2cpuflags/releases/download/v${PV}/${P}.tar.bz2
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86 ~x64-macos ~x64-solaris ~x86-solaris"
