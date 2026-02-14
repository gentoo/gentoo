# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool to manipulate Intel X86 and X86-64 processor microcode update collections"
HOMEPAGE="https://gitlab.com/iucode-tool/"
SRC_URI="https://gitlab.com/iucode-tool/releases/raw/master/${PN/_/-}_${PV}.tar.xz"
S="${WORKDIR}/${PN/_/-}-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="elibc_musl? ( sys-libs/argp-standalone )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.1-limits-include.patch
	"${FILESDIR}"/${PN}-2.3.1-non-x86.patch
)
