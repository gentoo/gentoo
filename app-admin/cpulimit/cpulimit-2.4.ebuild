# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Limits the CPU usage of a process"
HOMEPAGE="http://cpulimit.sourceforge.net"
SRC_URI="mirror://sourceforge/limitcpu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~riscv x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	tc-export CC
	# set correct VERSION
	#sed -i -e "/^#define VERSION/s@[[:digit:]\.]\+\$@${PV}@" cpulimit.c \
	#	|| die 'sed on VERSION string failed'

	default
}

src_install() {
	local DOCS=( CHANGELOG README )
	dosbin ${PN}
	doman ${PN}.1
	einstalldocs
}
