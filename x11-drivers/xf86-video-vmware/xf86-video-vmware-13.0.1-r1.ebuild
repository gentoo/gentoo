# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

XORG_DRI=always
XORG_EAUTORECONF=yes
inherit xorg-2

DESCRIPTION="VMware SVGA video driver"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libdrm[libkms,video_cards_vmware]
	>=media-libs/mesa-10[xa]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-damageunregister.patch
	"${FILESDIR}"/${P}-xatracker-2.patch
	"${FILESDIR}"/${P}-xa-compat-2.patch
)
