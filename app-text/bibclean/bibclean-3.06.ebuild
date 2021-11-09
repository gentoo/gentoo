# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="BibTeX bibliography prettyprinter and syntax checker"
HOMEPAGE="http://www.math.utah.edu/pub/bibclean/"
SRC_URI="ftp://ftp.math.utah.edu/pub/bibclean/${P}.tar.xz"

# http://packages.debian.org/changelogs/pool/main/b/bibclean/bibclean_2.11.4-5/bibclean.copyright
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"


src_compile() {
	emake LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin bibclean
	newman bibclean.man bibclean.1
}
