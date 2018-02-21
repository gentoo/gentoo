# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tool to guess CPU_FLAGS_X86 flags for the host"
HOMEPAGE="https://github.com/mgorny/cpuid2cpuflags"
SRC_URI="https://github.com/mgorny/cpuid2cpuflags/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-fbsd ~x86-fbsd ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

pkg_postinst() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		if [[ ${v%-r*} -lt 2 ]]; then
			elog 'Please note that the output has changed in v2. The new format is suitable'
			elog 'both for Portage and Paludis. To use it, e.g.:'
			elog
			elog '  $ echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpuflags'
			elog
			elog '(you may need to convert package.use into a directory if you want to use'
			elog ' separate file as presented here)'
		fi
	done
}
