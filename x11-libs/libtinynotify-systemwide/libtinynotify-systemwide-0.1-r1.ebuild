# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A system-wide notifications module for libtinynotify"
HOMEPAGE="https://github.com/projg2/libtinynotify-systemwide/"
SRC_URI="https://github.com/projg2/libtinynotify-systemwide/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-process/procps:=
	x11-libs/libtinynotify:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	econf --disable-gtk-doc
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
