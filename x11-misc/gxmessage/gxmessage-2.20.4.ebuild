# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg-utils

DESCRIPTION="A GTK+ based xmessage clone"
HOMEPAGE="https://savannah.gnu.org/projects/gxmessage/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="
	>=x11-libs/gtk+-2.20:2
"
DEPEND="
	${RDEPEND}
	>=dev-util/intltool-0.40.1
	sys-devel/gettext
	virtual/pkgconfig
"
DOCS=( AUTHORS ChangeLog HACKING NEWS README TODO )

src_install() {
	default

	docinto examples
	dodoc examples/*
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
