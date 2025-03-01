# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Examine the address space of a QEMU-based virtual machine"
HOMEPAGE="https://github.com/martinradev/gdb-pt-dump"

GDB_PT_DUMP_COMMIT="7ccdd8bb35762d24386990ba91e43da234fe7437"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/martinradev/gdb-pt-dump.git"
else
	SRC_URI="https://github.com/martinradev/gdb-pt-dump/archive/${GDB_PT_DUMP_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="amd64 ~arm64 x86"
	S="${WORKDIR}/${PN}-${GDB_PT_DUMP_COMMIT}"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-debug/gdb[python,${PYTHON_SINGLE_USEDEP}]
"
