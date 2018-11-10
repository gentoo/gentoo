# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit readme.gentoo-r1

DESCRIPTION="SaraB is a powerful and automated backup scheduling system based on DAR"
HOMEPAGE="http://sarab.sourceforge.net/"
SRC_URI="mirror://sourceforge/sarab/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-backup/dar
	virtual/mailx"

PATCHES=( "${FILESDIR}"/${PV}-better-defaults-gentoo.patch )

src_install() {
	dobin sarab.sh
	einstalldocs

	insinto /etc/sarab
	doins -r etc/.
	# sarab.conf could contain passphrase information
	fperms 600 /etc/sarab/sarab.conf

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	ewarn "The configuration format for DAR encryption has changed in Sarab 0.2.4."
	ewarn "Replace DAR_ENCRYPTION_OPTIONS=\"--key blowfish:PASSPHRASE\""
	ewarn "by SARAB_KEY=\"blowfish:PASSPHRASE\" in /etc/sarab/sarab.conf"
}
