# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool to guess CPU_FLAGS_* flags for the host"
HOMEPAGE="
	https://gitweb.gentoo.org/proj/cpuid2cpuflags.git/
	https://github.com/gentoo/cpuid2cpuflags/
"
SRC_URI="
	https://distfiles.gentoo.org/pub/dev/mgorny%40gentoo.org/cpuid2cpuflags/${P}.tar.bz2
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~x64-macos ~x64-solaris"
