# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/tinymount/tinymount-0.2.8.ebuild,v 1.2 2015/06/04 18:04:11 pesa Exp $

EAPI=5
PLOCALES="ru uk"
inherit l10n qt4-r2

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI=("https://github.com/limansky/${PN}.git")
	inherit git-r3
else
	SRC_URI="https://github.com/limansky/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Simple graphical utility for disk mounting"
HOMEPAGE="https://github.com/limansky/tinymount"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug libnotify"

COMMON_DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	libnotify? ( x11-libs/libnotify )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	sys-fs/udisks:0"

DOCS=( ChangeLog README.md )

src_prepare() {
	remove_locale() {
		sed -i -e "/translations\/${PN}_${1}.ts/d" src/src.pro || die
	}

	# Check for locales added/removed from previous version
	l10n_find_plocales_changes src/translations "${PN}_" .ts

	# Prevent disabled locales from being built
	l10n_for_each_disabled_locale_do remove_locale

	# Bug 441986
	sed -i -e 's|-Werror||g' src/src.pro || die

	qt4-r2_src_prepare
}

src_configure() {
	eqmake4 \
		PREFIX="${EPREFIX}/usr" \
		$(use libnotify && echo CONFIG+=with_libnotify)
}
