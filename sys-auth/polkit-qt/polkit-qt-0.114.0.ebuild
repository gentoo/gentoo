# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_ORG_NAME="polkit-qt-1"
inherit cmake kde.org

DESCRIPTION="Qt wrapper around polkit-1 client libraries"
HOMEPAGE="https://api.kde.org/polkit-qt-1/html/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${KDE_ORG_NAME}/${KDE_ORG_NAME}-${PV}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"
fi

LICENSE="LGPL-2"
SLOT="0"
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
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS README README.porting TODO )

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
	)
	cmake_src_configure
}
