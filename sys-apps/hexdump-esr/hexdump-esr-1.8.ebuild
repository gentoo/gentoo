# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

MY_P="${P/-esr/}"

DESCRIPTION="Eric Raymond's hex dumper"
HOMEPAGE="http://www.catb.org/~esr/hexdump/"
SRC_URI="http://www.catb.org/~esr/hexdump/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

S="${WORKDIR}/${MY_P}"

# tests are broken in this release(missing files)
RESTRICT="test"

src_prepare() {
	sed -i Makefile \
		-e "s|-O |${CFLAGS} ${LDFLAGS} |g" \
		|| die "sed on Makefile failed"
	tc-export CC
}

src_install() {
	newbin hexdump ${PN}
	newman hexdump.1 ${PN}.1
	dodoc NEWS README
	dosym ${PN} /usr/bin/hex
}
