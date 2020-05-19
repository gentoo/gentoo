# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs xdg-utils

DESCRIPTION="Periodic table application for Linux"
HOMEPAGE="https://sourceforge.net/projects/gperiodic/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"
RDEPEND="
	sys-libs/ncurses:0
	x11-libs/gtk+:2
	x11-libs/cairo[X]"
DEPEND="${RDEPEND}"

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC=$(tc-getCC) "enable_nls=$(usex nls 1 0)"
}

src_install() {
	emake DESTDIR="${D}" "enable_nls=$(usex nls 1 0)" install
	dodoc AUTHORS ChangeLog README
	newdoc po/README README.translation
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
