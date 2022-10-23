# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Additional image loaders for Imlib2"
HOMEPAGE="https://www.enlightenment.org/
	https://sourceforge.net/projects/enlightenment/files/imlib2-src/"
SRC_URI="https://downloads.sourceforge.net/enlightenment/${P}.tar.xz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris ~x86-solaris"
IUSE="xcf"

RDEPEND=">=media-libs/imlib2-${PV}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local myconf=(
		--disable-static
		$(use_enable xcf)
	)

	econf "${myconf[@]}"
}

src_install() {
	V=1 emake install DESTDIR="${D}"
	einstalldocs

	find "${D}" -name '*.la' -delete || die
}
