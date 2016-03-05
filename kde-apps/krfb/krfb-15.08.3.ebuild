# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="VNC-compatible server to share KDE desktops"
HOMEPAGE="https://www.kde.org/applications/system/krfb/"
KEYWORDS="amd64 ~x86"
IUSE="debug telepathy ktp"
REQUIRED_USE="ktp? ( telepathy )"

DEPEND="
	>=net-libs/libvncserver-0.9.9
	sys-libs/zlib
	virtual/jpeg:0
	!aqua? (
		x11-libs/libX11
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXtst
	)
	telepathy? ( >=net-libs/telepathy-qt-0.9 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with telepathy TelepathyQt4)
		$(cmake-utils_use_with ktp KTp)
	)

	kde4-base_src_configure
}
