# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Password storage/retrieval in a dockapp"
HOMEPAGE="https://sourceforge.net/projects/wmpasman/"
SRC_URI="https://downloads.sourceforge.net/wmpasman/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

RDEPEND="app-crypt/libsecret
	>=x11-libs/gtk+-3.8.0:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="ChangeLog WARNINGS"

PATCHES=( "${FILESDIR}"/${P}-ar.patch )

src_prepare() {
	default
	eautoreconf
}
