# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PLOCALES="cs sr"

inherit cmake-utils l10n

DESCRIPTION="Lightweight and cross-platform clipboard history applet"
HOMEPAGE="https://code.google.com/p/qlipper/"
SRC_URI="https://qlipper.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsingleapplication[qt4(+),X]
	x11-libs/libqxt
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-system-includes.patch"
)

src_prepare() {
	cmake-utils_src_prepare
	l10n_for_each_disabled_locale_do rm_ts
}

src_configure() {
	cmake-utils_src_configure INSTALL_PREFIX="${EPREFIX}"/usr
}

rm_ts() {
	rm -f "${S}"/ts/${PN}.${1}.ts
}
