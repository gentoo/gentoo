# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

MY_P="${PN}V${PV}"

DESCRIPTION="Fast multiple sequence alignments using partial-order graphs"
HOMEPAGE="http://bioinfo.mbi.ucla.edu/poa/"
SRC_URI="mirror://sourceforge/poamsa/${MY_P}.tar.gz"

# According to SF project page
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-respect-flags.patch
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		OPT_CFLAGS="${CFLAGS}" \
		poa
}

src_install() {
	dobin "${S}"/poa "${S}"/make_pscores.pl
	use static-libs && dolib.a "${S}"/liblpo.a
	dodoc "${S}"/README "${S}"/multidom.*
	insinto /usr/share/poa
	doins "${S}"/*.mat
}

pkg_postinst() {
	elog "poa requires a score matrix as the first argument."
	elog "This package installs two examples to ${EROOT}usr/share/poa/."
}
