# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="Applet for KDE Plasma and X clipboard management"
HOMEPAGE+=" https://userbase.kde.org/Klipper"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug prison"

DEPEND="
	kde-plasma/libkworkspace:4
	kde-plasma/libtaskmanager:4
	sys-libs/zlib
	x11-libs/libX11
	prison? ( kde-frameworks/prison:4 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with prison)
	)

	kde4-meta_src_configure
}
