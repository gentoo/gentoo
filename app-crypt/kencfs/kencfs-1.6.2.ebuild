# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils

DESCRIPTION="GUI frontend for encfs"
HOMEPAGE="http://kde-apps.org/content/show.php?content=134003"
SRC_URI="http://kde-apps.org/CONTENT/content-files/134003-${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	kde-base/kdelibs:4
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
