# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xorg-2

DESCRIPTION="X.Org video driver for NVIDIA Tegra"

SRC_URI="http://xorg.freedesktop.org/releases/individual/driver/${P}.tar.xz"
KEYWORDS="arm"
IUSE=""

RDEPEND="x11-libs/libdrm[video_cards_tegra]
	>=x11-base/xorg-server-1.13"
DEPEND="${RDEPEND}"
