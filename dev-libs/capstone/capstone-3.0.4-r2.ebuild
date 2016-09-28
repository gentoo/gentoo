# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="disassembly/disassembler framework + bindings"
HOMEPAGE="http://www.capstone-engine.org/"
SRC_URI="https://github.com/aquynh/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/3" # libcapstone.so.3
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	{
		cat <<-EOF
		# Gentoo overrides:
		#   verbose build
		V = 1
		#   toolchain
		AR = $(tc-getAR)
		CC = $(tc-getCC)
		RANLIB = $(tc-getRANLIB)
		#  toolchain flags
		CFLAGS = ${CFLAGS}
		LDFLAGS = ${LDFLAGS}
		#  libs
		LIBDIRARCH = $(get_libdir)
		EOF
	} >> config.mk || die

}
