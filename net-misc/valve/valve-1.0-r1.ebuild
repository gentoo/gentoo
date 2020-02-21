# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Copy data while enforcing a specified maximum transfer rate"
HOMEPAGE="https://www.fourmilab.ch/webtools/valve/"
SRC_URI="https://www.fourmilab.ch/webtools/valve/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test doc"
RESTRICT="!test? ( test )"

DOCS=( README INSTALL valve.pdf )

src_test() {
	emake check
}

src_install() {
	dodir /usr/share/man/man1 /usr/bin
	emake DESTDIR="${D}" install
	use doc && local HTML_DOCS=( index.html logo.png )
	einstalldocs
}
