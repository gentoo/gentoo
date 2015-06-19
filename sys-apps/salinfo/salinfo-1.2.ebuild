# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/salinfo/salinfo-1.2.ebuild,v 1.1 2014/03/30 06:28:51 vapier Exp $

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
