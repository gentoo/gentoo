# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Sets the region on DVD drives"
HOMEPAGE="http://linvdr.org/projects/regionset/"
SRC_URI="http://linvdr.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

src_prepare() {
	default
	sed "/^\.IR/s@${PN}@${PF}@" -i ${PN}.8 || die
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -o ${PN} ${PN}.c dvd_udf.c || die
}

src_install() {
	dosbin ${PN}
	doman ${PN}.8
	dodoc debian/changelog README
}

pkg_postinst() {
	ewarn "By default, regionset uses /dev/dvd, specify a different device"
	ewarn "as a command line argument if you need to. You need write access"
	ewarn "to do this, preferably as root."
	ewarn
	ewarn "Most drives can only have their region changed 4 or 5 times."
	ewarn
	ewarn "When you use regionset, you MUST have a cd or dvd in the drive"
	ewarn "otherwise nasty things will happen to your drive's firmware."
}
