# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A GTK program for doing Smith Chart calculations"
HOMEPAGE="https://www.qsl.net/ik5nax/"
SRC_URI="https://www.qsl.net/ik5nax/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-clang16-build-fix.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README TODO
	insinto /usr/share/${PN}
	doins example*
}
