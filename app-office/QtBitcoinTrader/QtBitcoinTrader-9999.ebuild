# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/QtBitcoinTrader/QtBitcoinTrader-9999.ebuild,v 1.6 2015/06/05 15:00:22 jlec Exp $

EAPI=5

if [[ $PV = *9999* ]]; then
	eclass=git-r3
	EGIT_REPO_URI="
		git://github.com/JulyIGHOR/QtBitcoinTrader.git
		https://github.com/JulyIGHOR/QtBitcoinTrader.git"
	EGIT_BRANCH="testing"
	SRC_URI=""
	KEYWORDS=""
else
	eclass=vcs-snapshot
	SRC_URI="https://github.com/JulyIGHOR/QtBitcoinTrader/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit base fdo-mime qmake-utils ${eclass}

DESCRIPTION="Mt.Gox and BTC-e Bitcoin Trading Client"
HOMEPAGE="https://github.com/JulyIGHOR/QtBitcoinTrader"

LICENSE="GPL-3"
SLOT="0"
IUSE="qt4 qt5"

REQUIRED_USE="
	^^ ( qt4 qt5 )
"

DEPEND="
	dev-libs/openssl:0
	sys-libs/zlib
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtmultimedia:4
		dev-qt/qtscript:4
		)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtscript:5
		dev-qt/qtwidgets:5
		dev-qt/qtmultimedia:5
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	if use qt4; then
		eqmake4 \
			src/${PN}_Desktop.pro \
			PREFIX="${EPREFIX}/usr" \
			DESKTOPDIR="${EPREFIX}/usr/share/applications" \
			ICONDIR="${EPREFIX}/usr/share/pixmaps"
	elif use qt5; then
		eqmake5 \
			src/${PN}_Desktop.pro \
			PREFIX="${EPREFIX}/usr" \
			DESKTOPDIR="${EPREFIX}/usr/share/applications" \
			ICONDIR="${EPREFIX}/usr/share/pixmaps"
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}
