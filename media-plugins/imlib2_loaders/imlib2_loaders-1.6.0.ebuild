# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Additional image loaders for Imlib2"
HOMEPAGE="https://www.enlightenment.org/
	https://sourceforge.net/projects/enlightenment/files/imlib2-src/"
SRC_URI="https://downloads.sourceforge.net/enlightenment/${P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="eet xcf"

RDEPEND=">=media-libs/imlib2-${PV}
	eet? ( dev-libs/efl[eet] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local myconf=(
		--disable-static
		$(use_enable eet)
		$(use_enable xcf)
	)

	econf "${myconf[@]}"
}

src_install() {
	V=1 emake install DESTDIR="${D}"
	einstalldocs

	find "${D}" -name '*.la' -delete || die
}
