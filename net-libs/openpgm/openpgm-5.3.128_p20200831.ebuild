# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
MY_COMMIT="a8914edbb13c521d05e941319c32dc754a7046ac"

inherit autotools python-any-r1

MY_PV="${PV//./-}"

DESCRIPTION="Open source implementation of the Pragmatic General Multicast specification"
HOMEPAGE="https://github.com/steve-o/openpgm"
SRC_URI="https://github.com/steve-o/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/5.3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="static-libs"

DEPEND="${PYTHON_DEPS}"

S="${WORKDIR}/${PN}-${MY_COMMIT}/${PN}/pgm"
DOCS=( "${S}"/../doc/. "${S}"/README )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
		local myeconfargs=(
				--enable-shared
				$(use_enable static-libs static)
		)
		econf "${myeconfargs[@]}"
}

src_install() {
		default
		find "${ED}"/usr/lib* -name '*.la' -delete || die
}
