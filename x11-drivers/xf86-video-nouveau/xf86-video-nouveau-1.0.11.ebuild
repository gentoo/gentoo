# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
XORG_DRI="always"
XORG_EAUTORECONF=yes
inherit xorg-2

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/nouveau/${PN}"
	SRC_URI=""
fi

DESCRIPTION="Accelerated Open Source driver for nVidia cards"
HOMEPAGE="http://nouveau.freedesktop.org/"

KEYWORDS="amd64 ppc ppc64 x86"
IUSE="glamor"

RDEPEND=">=x11-libs/libdrm-2.4.34[video_cards_nouveau]
	<x11-base/xorg-server-1.18.0[glamor(-)?]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-glamor-automagic.patch
)

src_configure() {
	XORG_CONFIGURE_OPTIONS="$(use_enable glamor)"
	xorg-2_src_configure
}
