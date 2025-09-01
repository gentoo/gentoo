# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_COMMIT="85e252a28981d479822092bad235bb75beb7edfa"

inherit autotools

DESCRIPTION="A SQL/SQLI tokenizer parser analyzer"
HOMEPAGE="https://github.com/libinjection/libinjection"
SRC_URI="
	https://github.com/libinjection/libinjection/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="virtual/pkgconfig"

src_prepare() {
	eautoreconf
	default
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
