# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/beforelight/beforelight-1.0.5.ebuild,v 1.4 2013/10/08 05:02:28 ago Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="Sample implementation of screen saver"
KEYWORDS="amd64 arm ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE=""
RDEPEND="x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXt
	x11-libs/libXaw"
DEPEND="${RDEPEND}"
