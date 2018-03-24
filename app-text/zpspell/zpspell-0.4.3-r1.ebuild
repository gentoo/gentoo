# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.3-add-gobject-linkage-11566.patch
)

DOCS=( AUTHORS README )

pkg_postinst() {
	elog "Please visit ${HOMEPAGE} for"
	elog "documentation on how to configure and run Zemberek spellchecker for KDE."
}
