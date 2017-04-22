# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A tool designed to help administrators keep track of their daily activities"
HOMEPAGE="http://www.deer-run.com/~hal/"
SRC_URI="http://www.far2wise.net/plod/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="dev-lang/perl"

DOCS=( README )

src_prepare() {
	default
	sed -i -e 's#/usr/local#/usr#' "${PN}" || die
}

src_compile() {
	:;
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1.gz"

	insinto /etc
	doins "${FILESDIR}/${PN}rc"
	einstalldocs
}
