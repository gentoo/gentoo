# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tools for configuring ISA PnP devices"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/system/hardware/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

PATCHES=( "${FILESDIR}"/${P}-include.patch )

src_install() {
	default

	dodir /sbin
	mv "${ED%/}"/{usr/sbin/isapnp,sbin/} || die

	docinto txt
	dodoc doc/{README*,*.txt} test/*.txt
	dodoc etc/isapnp.*

	newinitd "${FILESDIR}"/isapnp.rc isapnp
}
