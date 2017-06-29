# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A system-wide notifications module for libtinynotify"
HOMEPAGE="https://github.com/mgorny/libtinynotify-systemwide/"
SRC_URI="https://github.com/mgorny/libtinynotify-systemwide/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND="sys-process/procps:0=
	x11-libs/libtinynotify:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

src_configure() {
	local myconf=(
		$(use_enable doc gtk-doc)
		$(use_enable static-libs static)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
