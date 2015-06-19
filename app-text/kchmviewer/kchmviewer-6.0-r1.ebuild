# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/kchmviewer/kchmviewer-6.0-r1.ebuild,v 1.9 2015/06/04 19:00:59 kensington Exp $

EAPI=5
KDE_REQUIRED="optional"
KDE_LINGUAS="cs fr hu it nl pt_BR ru sv tr uk zh_CN zh_TW"
KDE_LINGUAS_DIR="po"

inherit base eutils fdo-mime qt4-r2 kde4-base

DESCRIPTION="A feature rich chm file viewer, based on Qt"
HOMEPAGE="http://www.kchmviewer.net/"
SRC_URI="mirror://sourceforge/kchmviewer/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug kde"

RDEPEND="
	dev-libs/chmlib
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
	kde? (
		$(add_kdebase_dep kdelibs)
		!kde-apps/okular[chm]
	)
"
DEPEND="${RDEPEND}"

pkg_setup() {
	use kde && kde4-base_pkg_setup
}

src_prepare() {
	base_src_prepare
	sed -e "s:KDE4_ICON_INSTALL_DIR:ICON_INSTALL_DIR:" \
		-e "s:KDE4_XDG_APPS_INSTALL_DIR:XDG_APPS_INSTALL_DIR:" \
			-i packages/CMakeLists.txt || die
	sed -e "s:KDE4_BIN_INSTALL_DIR:BIN_INSTALL_DIR:" \
			-i src/CMakeLists.txt || die
	echo "CONFIG += ordered" >> kchmviewer.pro # parallel build fix #281954

	sed -e "/Encoding=UTF-8/d" \
		-i packages/kchmviewer.desktop || die "fixing .desktop file failed"

	local lang
	for lang in ${KDE_LINGUAS} ; do
		if ! use linguas_${lang} ; then
			rm ${KDE_LINGUAS_DIR}/${PN}_${lang}.po
		fi
	done
}

src_configure() {
	if use kde; then
		kde4-base_src_configure
	else
		eqmake4
	fi
}

src_compile() {
	if use kde; then
		kde4-base_src_compile
	else
		default
	fi
}

src_install() {
	if use kde; then
		kde4-base_src_install
	else
		dobin bin/kchmviewer
		domenu packages/kchmviewer.desktop
		dodoc ChangeLog README
	fi
	doicon packages/kchmviewer.png
	dodoc DBUS-bindings FAQ
}

pkg_postinst() {
	use kde && kde4-base_pkg_postinst
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	use kde && kde4-base_pkg_postrm
	fdo-mime_desktop_database_update
}
