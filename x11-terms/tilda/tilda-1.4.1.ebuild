# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="A drop down terminal, similar to the consoles found in first person shooters"
HOMEPAGE="https://github.com/lanoxx/tilda"
SRC_URI="https://github.com/lanoxx/tilda/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="x11-libs/vte:2.91
	>=dev-libs/glib-2.8.4:2
	dev-libs/confuse
	gnome-base/libglade
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	default
	append-cflags -std=c99
	eautoreconf
}
