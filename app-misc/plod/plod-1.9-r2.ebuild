# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A tool to help administrators keep track of daily activities"
HOMEPAGE="http://www.deer-run.com/~hal/"
SRC_URI="http://www.far2wise.net/plod/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="dev-lang/perl"

src_unpack() {
	default

	# Bug 619934. Change directories first to ensure that "unpack" outputs
	# to ${S} and not to ${WORKDIR}.
	cd "${S}" || die
	unpack "${S}/${PN}.1.gz"
}

src_prepare() {
	default
	sed -i -e 's#/usr/local#/usr#' "${PN}" || die
}

src_compile() {
	:;
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"

	insinto /etc
	doins "${FILESDIR}/${PN}rc"

	dodoc README TODO
}
