# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs eutils

DESCRIPTION="decode Itanium SAL records (e.g. various hardware errors)"
HOMEPAGE="https://www.kernel.org/pub/linux/kernel/people/helgaas/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ia64"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
}

src_configure() {
	tc-export CC
}

src_install() {
	default
	rm -rf "${ED}"/etc/{rc.d,sysconfig} "${ED}"/var || die
}
