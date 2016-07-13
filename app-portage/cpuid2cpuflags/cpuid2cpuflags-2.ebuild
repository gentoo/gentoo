# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P=cpuinfo2cpuflags-${PV}
DESCRIPTION="Tool to guess CPU_FLAGS_X86 flags for the host"
HOMEPAGE="https://github.com/mgorny/cpuid2cpuflags"
SRC_URI="https://github.com/mgorny/cpuid2cpuflags/releases/download/v${PV}/${MY_P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-fbsd ~x86-fbsd ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

S=${WORKDIR}/${MY_P}
