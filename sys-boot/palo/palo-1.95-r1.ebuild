# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="PALO : PArisc Linux Loader"
HOMEPAGE="http://parisc-linux.org/ https://parisc.wiki.kernel.org/"
SRC_URI="mirror://debian/pool/main/p/${PN}/${P/-/_}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* hppa"

PATCHES=(
	"${FILESDIR}"/${PN}-1.95-toolchain.patch
	"${FILESDIR}"/${PN}-1.95-iplboot-gcc-4.9.patch
)

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
	dodoc Changes TODO debian/changelog README.html

	insinto /etc
	doins "${FILESDIR}"/palo.conf

	insinto /usr/share/palo
	doins iplboot

	insinto /etc/kernel/postinst.d/
	insopts -m 0744
	doins "${FILESDIR}"/99palo
}
