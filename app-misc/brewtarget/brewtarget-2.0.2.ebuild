# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/brewtarget/brewtarget-2.0.2.ebuild,v 1.2 2014/12/31 12:46:52 kensington Exp $

EAPI=5

PLOCALES="ca cs de en es fr hu it nb nl pl pt ru sv"

inherit cmake-utils l10n

DESCRIPTION="Application to create and manage beer recipes"
HOMEPAGE="http://www.brewtarget.org/"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3 WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="kde phonon"

DEPEND="
	>=dev-qt/qtcore-4.8:4
	>=dev-qt/qtgui-4.8:4
	>=dev-qt/qtsql-4.8:4[sqlite]
	>=dev-qt/qtsvg-4.8:4
	>=dev-qt/qtwebkit-4.8:4
	phonon? (
		kde? ( media-libs/phonon[qt4] )
		!kde? ( || ( >=dev-qt/qtphonon-4.8:4 media-libs/phonon[qt4] ) )
	)
"
RDEPEND="${DEPEND}"

remove_locale() {
	sed -i -e "/bt_$1.ts/d" CMakeLists.txt || die
}

src_prepare() {
	# Check for new locales, respect LINGUAS
	l10n_find_plocales_changes "${S}/translations" bt_ .ts
	l10n_for_each_disabled_locale_do remove_locale

	# Fix desktop file
	sed -i -e '/^Encoding=/d' ${PN}.desktop.in || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDO_RELEASE_BUILD=ON
		-DNO_MESSING_WITH_FLAGS=ON
		$(cmake-utils_use_no phonon)
	)
	cmake-utils_src_configure
}
