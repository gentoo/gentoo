# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xorg-2

DESCRIPTION="SiS and XGI video driver"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86 ~x86-fbsd"

DEPEND=">=x11-proto/xf86dgaproto-2.1"

PATCHES=(
	"${FILESDIR}"/${P}-fix-arguments-for-misetpointerposition.patch
	"${FILESDIR}"/${P}-block-wakeuphandler-abi-23.patch
)
