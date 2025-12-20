# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="An interactive vi tutorial comprised of 5 tutorials for the vi-impaired"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~riscv x86"
IUSE=""

RDEPEND="app-editors/vim"

DOCS=( README outline )

src_prepare() {
	default

	sed -i "s:/usr/local:${EPREFIX}/usr:" Makefile
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	einstalldocs

	insinto /usr/lib/${PN}
	doins [0-9]*
}
