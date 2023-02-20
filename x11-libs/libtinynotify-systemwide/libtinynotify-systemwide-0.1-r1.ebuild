# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A system-wide notifications module for libtinynotify"
HOMEPAGE="https://github.com/mgorny/libtinynotify-systemwide/"
SRC_URI="https://github.com/mgorny/libtinynotify-systemwide/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	sys-process/procps:=
	x11-libs/libtinynotify:="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

src_configure() {
	econf $(use_enable doc gtk-doc)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
