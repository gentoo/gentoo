# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools multilib-minimal

DESCRIPTION="Onigmo is a regular expressions library forked from Oniguruma"
HOMEPAGE="https://github.com/k-takata/Onigmo"
SRC_URI="https://github.com/k-takata/${PN^o}/releases/download/${P^o}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/6"
KEYWORDS="amd64 x86"
IUSE="combination-explosion-check crnl-as-line-terminator static-libs"

DOCS=( AUTHORS HISTORY README{,.ja} doc/{API,FAQ,RE}{,.ja} doc/UnicodeProps.txt )

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable combination-explosion-check) \
		$(use_enable crnl-as-line-terminator) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name "*.la" -delete || die
}
