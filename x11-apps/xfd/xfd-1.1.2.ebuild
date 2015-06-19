# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xfd/xfd-1.1.2.ebuild,v 1.8 2013/10/08 05:03:38 ago Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="X.Org xfd application"
KEYWORDS="amd64 arm hppa ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

RDEPEND="media-libs/freetype:2
	media-libs/fontconfig
	x11-libs/libXft
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXaw"
DEPEND="${RDEPEND}
	sys-devel/gettext"
