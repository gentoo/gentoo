# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Utility allowing you to use the Super key as a shortcut"
HOMEPAGE="https://www.linux-apps.com/content/show.php/ksuperkey?content=154569"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1460972657/154569-${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXtst
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

pkg_setup() {
	tc-export CC
}
