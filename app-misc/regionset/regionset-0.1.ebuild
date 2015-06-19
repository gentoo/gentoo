# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/regionset/regionset-0.1.ebuild,v 1.9 2008/11/26 17:50:56 beandog Exp $

inherit toolchain-funcs

DESCRIPTION="Sets the region on DVD drives"
HOMEPAGE="http://linvdr.org/projects/regionset/"
SRC_URI="http://linvdr.org/download/regionset/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)" all || die
}

src_install() {
	dosbin regionset || die
	dodoc ChangeLog README
}

pkg_postinst() {
	ewarn "By default regionset uses /dev/dvd, specify a different device"
	ewarn "as a command line argument if you need to. You need write access"
	ewarn "to do this, preferably as root."
	ewarn
	ewarn "Most drives can only have their region changed 4 or 5 times."
	ewarn
	ewarn "When you use regionset, you MUST have a cd or dvd in the drive"
	ewarn "otherwise nasty things will happen to your drive's firmware."
}
