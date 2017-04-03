# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Password storage/retrieval in a dockapp"
HOMEPAGE="https://sourceforge.net/projects/wmpasman/"
SRC_URI="mirror://sourceforge/wmpasman/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="app-crypt/libsecret
	>=x11-libs/gtk+-3.8.0:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="ChangeLog WARNINGS"
