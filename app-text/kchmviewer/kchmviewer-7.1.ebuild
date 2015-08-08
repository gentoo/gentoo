# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_REQUIRED="optional"
KDE_LINGUAS="cs fr hu it nl pt_BR ru sv tr uk zh_CN zh_TW"
inherit eutils fdo-mime kde4-base qmake-utils

DESCRIPTION="A feature rich chm file viewer, based on Qt"
HOMEPAGE="http://www.kchmviewer.net/"
SRC_URI="mirror://sourceforge/kchmviewer/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug kde"

RDEPEND="
	dev-libs/chmlib
	dev-libs/libzip
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
	local lang
	for lang in ${KDE_LINGUAS} ; do
		if ! use linguas_${lang} ; then
			rm po/${PN}_${lang}.po
		fi
	done

	# fix parallel build wrt bug #527192
	echo "src.depends = lib" >> ${PN}.pro || die
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
	dodoc DBUS-bindings FAQ
	doicon packages/kchmviewer.png

	if use kde; then
		kde4-base_src_install
	else
		dobin bin/kchmviewer
		domenu packages/kchmviewer.desktop
		dodoc ChangeLog README
	fi

}

pkg_postinst() {
	if use kde; then
		kde4-base_pkg_postinst
	else
		fdo-mime_desktop_database_update
	fi
}

pkg_postrm() {
	if use kde; then
		kde4-base_pkg_postrm
	else
		fdo-mime_desktop_database_update
	fi
}
