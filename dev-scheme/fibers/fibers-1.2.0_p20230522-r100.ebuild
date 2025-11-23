# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit autotools guile

[[ ${PV} == *_p20230522 ]] && COMMIT=83712f630a976e3084329c9917c40bde19fcc7e5

DESCRIPTION="Lightweight concurrency facility for Guile Scheme"
HOMEPAGE="https://github.com/wingo/fibers/
	https://github.com/wingo/fibers/wiki/Manual/"
SRC_URI="https://github.com/wingo/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="${GUILE_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	guile_src_prepare

	eautoreconf
}

src_configure() {
	guile_foreach_impl econf --disable-Werror
}

src_install() {
	guile_src_install

	find "${ED}" -type f -name "*.la" -delete || die
}
