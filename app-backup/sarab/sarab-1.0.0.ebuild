# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/sarab/sarab-1.0.0.ebuild,v 1.4 2014/08/10 01:54:01 patrick Exp $

inherit eutils

DESCRIPTION="SaraB is a powerful and automated backup scheduling system based on DAR"
HOMEPAGE="http://sarab.sourceforge.net/"
SRC_URI="mirror://sourceforge/sarab/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="app-backup/dar
	virtual/mailx"

src_unpack() {
	cd "${S}"
	unpack ${A}

	epatch "${FILESDIR}"/${PV}-better-defaults-gentoo.patch
}

src_install() {
	dobin sarab.sh
	insinto /etc/sarab
	doins -r etc/*
	# sarab.conf could contain passphrase information
	fperms 600 /etc/sarab/sarab.conf
	dodoc CHANGELOG FAQ INSTALL README
	dodoc "${FILESDIR}"/README.Gentoo
}

pkg_postinstl() {
	ewarn "The configuration format for DAR encryption has changed in Sarab 0.2.4."
	ewarn "Replace DAR_ENCRYPTION_OPTIONS=\"--key blowfish:PASSPHRASE\""
	ewarn "by SARAB_KEY=\"blowfish:PASSPHRASE\" in /etc/sarab/sarab.conf"
}
