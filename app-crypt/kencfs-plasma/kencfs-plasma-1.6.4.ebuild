# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/-plasma/}"
inherit qmake-utils

DESCRIPTION="GUI frontend for encfs"
HOMEPAGE="https://www.linux-apps.com/content/show.php?content=134003"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1486311191/${MY_PN}-${PV}.tar.gz"

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
	kde-frameworks/kwallet:5
	sys-fs/encfs
"

PATCHES=(
	"${FILESDIR}/${MY_PN}-1.4.0-encfs5.patch"
	"${FILESDIR}/${MY_PN}-1.6.2-desktop.patch"
)

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default

	sed -i ${MY_PN}.pro -e "/^doc.path =/s/${MY_PN}/${MY_PN}-${PVR}/" \
		|| die "sed docdir failed"
}

src_configure() {
	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
