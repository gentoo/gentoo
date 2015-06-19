# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm_icons/fvwm_icons-1.0.ebuild,v 1.17 2011/11/11 17:16:53 ssuominen Exp $

DESCRIPTION="Icons for use with FVWM"
HOMEPAGE="http://www.fvwm.org/"
SRC_URI="http://www.fvwm.org/generated/icon_download/fvwm_icons.tar.bz2"

LICENSE="GPL-2 FVWM"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-wm/fvwm-2.6.2"
DEPEND=""

S=${WORKDIR}/${PN}

src_install() {
	dodir /usr/share/icons/fvwm
	insinto /usr/share/icons/fvwm
	doins "${S}"/*
}
