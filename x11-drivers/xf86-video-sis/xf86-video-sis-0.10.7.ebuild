# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
XORG_DRI=dri
inherit xorg-2

DESCRIPTION="SiS and XGI video driver"
KEYWORDS="amd64 ia64 ppc x86 ~x86-fbsd"
IUSE="dri"

DEPEND=">=x11-proto/xf86dgaproto-2.1"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable dri)
	)
}
