# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/palo/palo-1.95.ebuild,v 1.2 2015/01/19 11:16:07 jer Exp $

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="PALO : PArisc Linux Loader"
HOMEPAGE="http://parisc-linux.org/ https://parisc.wiki.kernel.org/"
SRC_URI="mirror://debian/pool/main/p/${PN}/${P/-/_}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* hppa"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.95-toolchain.patch
}

src_compile() {
	local target
	for target in '-C palo' '-C ipl' 'iplboot'; do
		emake AR=$(tc-getAR) CC=$(tc-getCC) LD=$(tc-getLD) ${target}
	done
}

src_install() {
	into /
	dosbin palo/palo

	doman palo.8
	dohtml README.html
	dodoc Changes TODO debian/changelog

	insinto /etc
	doins "${FILESDIR}"/palo.conf

	insinto /usr/share/palo
	doins iplboot

	insinto /etc/kernel/postinst.d/
	INSOPTIONS="-m 0744" doins "${FILESDIR}"/99palo
}
