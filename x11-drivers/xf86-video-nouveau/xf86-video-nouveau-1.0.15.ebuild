# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
XORG_DRI="always"
inherit xorg-2

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/nouveau/xf86-video-nouveau.git"
	SRC_URI=""
fi

DESCRIPTION="Accelerated Open Source driver for nVidia cards"
HOMEPAGE="https://nouveau.freedesktop.org/wiki/"

KEYWORDS="amd64 ~arm64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=x11-libs/libdrm-2.4.60[video_cards_nouveau]
	>=x11-libs/libpciaccess-0.10"
DEPEND="${RDEPEND}"
