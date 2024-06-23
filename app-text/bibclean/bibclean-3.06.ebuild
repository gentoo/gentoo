# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="BibTeX bibliography prettyprinter and syntax checker"
HOMEPAGE="https://ftp.math.utah.edu/pub/bibclean/"
SRC_URI="https://ftp.math.utah.edu/pub/bibclean/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"

src_compile() {
	emake LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin bibclean
	newman bibclean.man bibclean.1
}
