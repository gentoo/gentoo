# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="GUI frontend for encfs"
HOMEPAGE="https://www.linux-apps.com/content/show.php?content=134003"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1486311191/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	kde-frameworks/kdelibs:4
"
RDEPEND="${DEPEND}
	kde-apps/kwalletd:4
	sys-fs/encfs
"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.0-encfs5.patch"
	"${FILESDIR}/${PN}-1.6.2-desktop.patch"
)

src_prepare() {
	default

	sed -i ${PN}.pro -e "/^doc.path =/s/${PN}/${PF}/" \
		|| die "sed docdir failed"
}

src_configure() {
	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
