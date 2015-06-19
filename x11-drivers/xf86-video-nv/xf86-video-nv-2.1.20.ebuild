# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-nv/xf86-video-nv-2.1.20.ebuild,v 1.9 2013/03/12 16:44:51 chithanh Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="Nvidia 2D only video driver"

KEYWORDS="alpha amd64 ia64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="x11-base/xorg-server
	>=x11-libs/libpciaccess-0.10.7"
DEPEND="${RDEPEND}"
