# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/fosnola/libstaroffice.git"
[[ ${PV} == 9999 ]] && inherit git-r3 autotools

DESCRIPTION="Import filter for old StarOffice documents"
HOMEPAGE="https://github.com/fosnola/libstaroffice"
[[ ${PV} == 9999 ]] || SRC_URI="http://dev-www.libreoffice.org/src/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1+ MPL-2.0 )"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

IUSE="debug doc tools +zlib"

RDEPEND="
	dev-libs/librevenge
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--disable-werror \
		$(use_enable debug) \
		$(use_with doc docs) \
		$(use_enable tools) \
		$(use_enable zlib zip)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
