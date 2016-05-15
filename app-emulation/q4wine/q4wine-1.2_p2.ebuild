# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PLOCALES="af_ZA cs_CZ de_DE en_US es_ES fa_IR he_IL it_IT pl_PL pt_BR ru_RU uk_UA"
PLOCALE_BACKUP="en_US"

inherit cmake-utils l10n

DESCRIPTION="Qt4 GUI configuration tool for Wine"
HOMEPAGE="http://q4wine.brezblock.org.ua/"

# Upstream names the package PV-rX. We change that to
# PV_pX so we can use portage revisions.
MY_PV="${PV/_p/-r}"
MY_P="${PN}-${MY_PV}"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PN}%20${MY_PV}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dbus debug +icoutils qt5 +wineappdb"

DEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsingleapplication[qt5(+),X]
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		dbus? ( dev-qt/qtdbus:5 )
	)
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtsingleapplication[qt4(+),X]
		dev-qt/qtsql:4[sqlite]
		dbus? ( dev-qt/qtdbus:4 )
	)
"
RDEPEND="${DEPEND}
	app-admin/sudo
	app-emulation/wine
	>=sys-apps/which-2.19
	sys-fs/fuseiso
	icoutils? ( >=media-gfx/icoutils-0.26.0 )
"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	local enabled_linguas
	construct_LINGUAS() {
		local current_locale="$(echo ${1} | tr '[:upper:]' '[:lower:]')"
		enabled_linguas="${enabled_linguas};${current_locale}"
	}
	l10n_for_each_locale_do construct_LINGUAS
	local mycmakeargs=(
		-DLINGUAS="${enabled_linguas}"
		-DWITH_SYSTEM_SINGLEAPP=ON
		$(cmake-utils_use debug)
		$(cmake-utils_use qt5)
		$(cmake-utils_use_with dbus)
		$(cmake-utils_use_with icoutils)
		$(cmake-utils_use_with wineappdb)
	)
	cmake-utils_src_configure
}
