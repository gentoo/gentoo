# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit qmake-utils

DESCRIPTION="A Japanese input method which supports the XIM protocol"
HOMEPAGE="http://kimera.osdn.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/37271/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+anthy"

RDEPEND="dev-qt/qt3support:4
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	anthy? ( app-i18n/anthy )
	!anthy? ( app-i18n/canna )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-underlinking.patch )

src_configure() {
	local myconf=(
		script.path="${EPREFIX}"/usr/bin
		target.path="${EPREFIX}"/usr/$(get_libdir)/${P}
		no_anthy=$(usex anthy 1 0)
	)
	eqmake4 ${PN}.pro "${myconf[@]}"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
