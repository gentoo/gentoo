# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/zpspell/zpspell-0.4.3-r1.ebuild,v 1.4 2014/08/10 18:38:55 slyfox Exp $

EAPI="5"

inherit cmake-utils

DESCRIPTION="Zemberek-Pardus spell checker interface"
HOMEPAGE="http://www.pardus.org.tr/projeler/masaustu/zemberek-pardus"
SRC_URI="http://cekirdek.uludag.org.tr/~baris/zpspell/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-libs/dbus-glib"
RDEPEND="${DEPEND}
	app-text/zemberek-server"

PATCHES=( "${FILESDIR}/add-gobject-linkage-11566.diff" )
DOCS=( AUTHORS README )

pkg_postinst() {
	elog "Please visit ${HOMEPAGE} for"
	elog "documentation on how to configure and run Zemberek spellchecker for KDE."
}
