# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils readme.gentoo

DESCRIPTION="Graphical display of directories and globs referenced at the shell prompt"
HOMEPAGE="http://viewglob.sourceforge.net/"
SRC_URI="mirror://sourceforge/viewglob/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	|| ( app-shells/bash:* app-shells/zsh )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-underlinking.patch
	"${FILESDIR}"/${P}-format-security.patch
)

src_install() {
	autotools-utils_src_install
	readme.gentoo_src_install
}
