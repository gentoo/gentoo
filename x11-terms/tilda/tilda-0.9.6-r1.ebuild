# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="A drop down terminal, similar to the consoles found in first person shooters"
HOMEPAGE="http://tilda.sourceforge.net"
SRC_URI="mirror://sourceforge/tilda/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="x11-libs/vte:0
	>=dev-libs/glib-2.8.4:2
	dev-libs/confuse
	gnome-base/libglade"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.9.6-gdk_resources.patch
	epatch "${FILESDIR}"/${PN}-0.9.6-glib-single-include.patch
	epatch "${FILESDIR}"/${PN}-0.9.6-makefile.patch
	eapply_user

	eautoreconf
}
