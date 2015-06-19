# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/gfsview/gfsview-20120706.ebuild,v 1.1 2012/08/07 00:52:47 bicatali Exp $

EAPI=4

inherit autotools-utils

MYP=${P/-20/-snapshot-}

DESCRIPTION="Graphical viewer for Gerris simulation files"
HOMEPAGE="http://gfs.sourceforge.net/"
SRC_URI="http://gerris.dalembert.upmc.fr/gerris/tarballs/${MYP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="sci-libs/gerris
	media-libs/ftgl
	media-libs/mesa[osmesa]
	x11-libs/gtk+:2
	>=x11-libs/gtkglext-1.0.6
	x11-libs/startup-notification"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

export LIBS=-lGL
