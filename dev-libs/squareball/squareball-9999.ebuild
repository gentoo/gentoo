# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/rafaelmartins/${PN}.git"
	inherit autotools git-r3
fi

DESCRIPTION="A general-purpose library for C99"
HOMEPAGE="https://github.com/rafaelmartins/squareball"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/rafaelmartins/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="doc test static-libs"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
DEPEND="test? ( dev-util/cmocka )"

src_prepare() {
	[[ ${PV} = *9999* ]] && eautoreconf
	default
}

src_configure() {
	econf \
		$(use_enable doc) \
		$(use_enable test tests) \
		$(use_enable static-libs static) \
		--disable-valgrind
}

src_compile() {
	default
	use doc && emake docs
}

src_install() {
	use doc && HTML_DOCS=( doc/build/html/* )
	default

	find "${ED}" -name '*.la' -delete || die
}
