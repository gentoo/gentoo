# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-modesetting/xf86-video-modesetting-0.9.0.ebuild,v 1.10 2015/03/14 14:06:08 maekke Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="Unaccelerated generic driver for kernel modesetting"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/libdrm-2.4.46"
DEPEND="${RDEPEND}"
