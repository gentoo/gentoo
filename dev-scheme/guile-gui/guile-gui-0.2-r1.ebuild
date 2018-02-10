# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Guile Scheme code that aims to implement a graphical user interface"
HOMEPAGE="http://www.ossau.uklinux.net/guile/"
SRC_URI="http://www.ossau.uklinux.net/guile/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-scheme/guile
	x11-libs/guile-gtk"
DEPEND="${RDEPEND}"
