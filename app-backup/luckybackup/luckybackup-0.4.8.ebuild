# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/luckybackup/luckybackup-0.4.8.ebuild,v 1.1 2014/04/29 09:19:13 pinkbyte Exp $

EAPI=5

PLOCALES="bs ca cs de el en es fr it nl no pl pt_BR ro ru sk sl sv tr zh_TW"
inherit l10n qt4-r2

DESCRIPTION="Powerful and flexible backup (and syncing) tool, using RSync and Qt4"
HOMEPAGE="http://luckybackup.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}
	net-misc/rsync"

DOCS=( readme/{AUTHORS,README,TODO,TRANSLATIONS,changelog} )

rm_loc() {
	sed -i -e "s|translations/${PN}_${1}.ts||" "${PN}.pro" || die 'sed on translations failed'
	rm "translations/${PN}_${1}."{ts,qm} || die "removing ${1} locale failed"
}

src_prepare() {
	sed -i \
		-e "s:/usr/share/doc/${PN}:/usr/share/doc/${PF}:g" \
		-e "s:/usr/share/doc/packages/${PN}:/usr/share/doc/${PF}:g" \
		luckybackup.pro src/global.h || die "sed failed"

	# The su-to-root command is an ubuntu-specific script so it will
	# not work with Gentoo. No reason to have it anyway.
	sed -i -e "/^Exec/s:=.*:=/usr/bin/${PN}:" menu/${PN}-gnome-su.desktop \
		|| die "failed to remove su-to-root"

	# causes empty directory to be installed
	sed -i -e '/^INSTALLS/s/debianmenu //' luckybackup.pro \
		|| die "sed installs failed"

	# remove text version - cannot remote HTML version
	# as it's used within the application
	rm license/gpl.txt || die "rm failed"

	l10n_find_plocales_changes "translations" "${PN}_" ".ts"
	l10n_for_each_disabled_locale_do rm_loc
	qt4-r2_src_prepare
}
