# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/_alpha/a}"
inherit qmake-utils

DESCRIPTION="GUI frontend for encfs"
HOMEPAGE="https://www.linux-apps.com/p/1170068/"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${MY_P}.tar.gz"

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
	"${FILESDIR}/${PN}-2.0.1_alpha-include.patch"
	"${FILESDIR}/${PN}-2.0.1_alpha-qt-5.11.patch"
)

src_prepare() {
	default

	sed -i ${PN}.pro -e "/^INSTALLS/s/ doc//" || die

	# fix desktop validation
	sed -i ${PN}.desktop -e "s|kencfs-plasma/kencfs-icon|/usr/share/icons/&.png|" || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
