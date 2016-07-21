# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xorg-2

DESCRIPTION="Generic VESA video driver"
KEYWORDS="-* alpha amd64 ~ia64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.6
	>=x11-libs/libpciaccess-0.12.901"
DEPEND="${RDEPEND}"
