# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN}-1"
MY_P="${MY_PN}-${PV}"
inherit cmake-utils

DESCRIPTION="Qt wrapper around polkit-1 client libraries"
HOMEPAGE="https://api.kde.org/kdesupport-api/polkit-qt-1-apidocs/"
SRC_URI="mirror://kde/stable/${MY_PN}/${MY_P}.tar.xz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="debug"

RDEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=sys-auth/polkit-0.103
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README README.porting TODO )

S="${WORKDIR}/${MY_P}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
	)

	cmake-utils_src_configure
}
