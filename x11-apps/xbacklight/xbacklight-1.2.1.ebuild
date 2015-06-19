# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xbacklight/xbacklight-1.2.1.ebuild,v 1.10 2014/06/08 09:15:39 ago Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="Sets backlight level using the RandR 1.2 BACKLIGHT output property"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libxcb
	>=x11-libs/xcb-util-0.3.8"
DEPEND="${RDEPEND}"
