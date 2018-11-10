# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/_alpha/a}"
inherit qmake-utils

DESCRIPTION="GUI frontend for encfs"
HOMEPAGE="https://www.linux-apps.com/p/1170068/"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1486310914/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	kde-frameworks/kconfig:5
	kde-frameworks/knotifications:5
	kde-frameworks/kwallet:5
"
RDEPEND="${DEPEND}
	sys-fs/encfs
"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${P}-include.patch"
	"${FILESDIR}/${P}-qt-5.11.patch"
)

src_prepare() {
	default

	sed -i ${PN}.pro -e "/^doc.path =/s/$/${PF}/" || die

	# fix desktop validation
	sed -i ${PN}.desktop -e "s|kencfs-plasma/kencfs-icon|/usr/share/icons/&.png|" || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
