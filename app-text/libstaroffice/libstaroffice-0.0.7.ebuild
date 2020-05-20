# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/fosnola/libstaroffice.git"
	inherit git-r3 autotools
else
	SRC_URI="https://github.com/fosnola/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~ppc64 ~x86"
fi

DESCRIPTION="Import filter for old StarOffice documents"
HOMEPAGE="https://github.com/fosnola/libstaroffice"

LICENSE="|| ( LGPL-2.1+ MPL-2.0 )"
SLOT="0"
IUSE="debug doc tools +zlib"

BDEPEND="
	doc? ( app-doc/doxygen )
"
DEPEND="
	dev-libs/librevenge
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	[[ ${PV} == *9999* ]] && eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_with doc docs)
		$(use_enable tools)
		$(use_enable zlib zip)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
