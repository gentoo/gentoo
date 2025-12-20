# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="libraries"
KDE_ORG_NAME="polkit-qt-1"
inherit cmake kde.org

DESCRIPTION="Qt wrapper around polkit-1 client libraries"
HOMEPAGE="https://api.kde.org/legacy/polkit-qt-1/html/index.html"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${KDE_ORG_NAME}/${KDE_ORG_NAME}-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2"
SLOT="0"

RDEPEND="
	dev-libs/glib:2
	dev-qt/qtbase:6[dbus,gui,widgets]
	>=sys-auth/polkit-0.103
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS README README.porting TODO )

PATCHES=( "${FILESDIR}/${P}-uniquify-identities.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
		-DQT_MAJOR_VERSION=6
	)
	cmake_src_configure
}
