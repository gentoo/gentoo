# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://git.code.sf.net/p/libmwaw/libmwaw"
	inherit autotools git-r3
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="Library parsing many pre-OSX MAC text formats"
HOMEPAGE="https://sourceforge.net/p/libmwaw/wiki/Home/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc static-libs tools"

BDEPEND="
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
DEPEND="
	dev-libs/librevenge
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	# zip is hard enabled as the zlib is dep on the rdeps anyway
	local myeconfargs=(
		--enable-zip
		--disable-werror
		$(use_with doc docs)
		$(use_enable static-libs static)
		$(use_enable tools)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
