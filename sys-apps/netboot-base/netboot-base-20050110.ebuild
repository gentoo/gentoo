# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Baselayout for netboot systems"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://dev.gentoo.org/~vapier/${P}.tar.bz2
	mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha arm hppa ~mips ppc sh sparc x86"
IUSE=""

DEPEND=""

S=${WORKDIR}

pkg_setup() {
	[[ ${ROOT} = "/" ]] && die "refusing to emerge to /"
}

src_compile() {
	$(tc-getCC) ${CFLAGS} src/consoletype.c -o sbin/consoletype || die
	$(tc-getSTRIP) --strip-unneeded sbin/consoletype
}

src_install() {
	rm -r src
	cp -r * "${D}"/ || die
}

pkg_preinst() {
	[[ ${ROOT} = "/" ]] && die "refusing to install to /"
}

pkg_postinst() {
	cd "${ROOT}"
	mkdir -p bin dev etc lib mnt proc sbin var
	mkdir -p var/log
	mkdir -p mnt/gentoo
	ln -s . usr
	ln -s . share
}
