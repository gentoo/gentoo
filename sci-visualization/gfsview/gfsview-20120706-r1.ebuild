# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils toolchain-funcs

MYP=${P/-20/-snapshot-}

DESCRIPTION="Graphical viewer for Gerris simulation files"
HOMEPAGE="http://gfs.sourceforge.net/"
SRC_URI="http://gerris.dalembert.upmc.fr/gerris/tarballs/${MYP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="
	sci-libs/gerris
	media-libs/ftgl
	media-libs/mesa[osmesa,X(+)]
	x11-libs/gtk+:2
	>=x11-libs/gtkglext-1.0.6
	x11-libs/startup-notification
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

src_prepare() {
	export LIBS="$($(tc-getPKG_CONFIG) --libs gl)"
	autotools-utils_src_prepare
}
