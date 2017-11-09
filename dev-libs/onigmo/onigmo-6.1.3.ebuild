# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Onigmo is a regular expressions library forked from Oniguruma"
HOMEPAGE="https://github.com/k-takata/onigmo"
SRC_URI="https://github.com/k-takata/${PN}/archive/Onigmo-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/6"
KEYWORDS="~amd64"
IUSE="combination-explosion-check crnl-as-line-terminator static-libs"

S="${WORKDIR}/Onigmo-Onigmo-${PV}"

DOCS=(AUTHORS HISTORY README{,.ja} doc/{API,FAQ,RE}{,.ja} doc/UnicodeProps.txt)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable combination-explosion-check) \
		$(use_enable crnl-as-line-terminator) \
		$(use_enable static-libs static)
}

src_install() {
	default
	einstalldocs
	find "${D}" -name "*.la" -delete || die
}
