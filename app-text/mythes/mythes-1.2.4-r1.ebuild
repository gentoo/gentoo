# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A simple thesaurus for Libreoffice"
HOMEPAGE="http://hunspell.sourceforge.net/"
SRC_URI="mirror://sourceforge/hunspell/MyThes/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="app-text/hunspell"
DEPEND="${DEPEND}
	virtual/pkgconfig"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
