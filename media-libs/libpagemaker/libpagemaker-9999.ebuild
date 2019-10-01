# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="git://gerrit.libreoffice.org/${PN}.git"
	inherit autotools git-r3
else
	SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi
DESCRIPTION="C++ Library that parses the file format of Aldus/Adobe PageMaker documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/${PN}"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="debug doc tools"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-libs/librevenge
"
DEPEND="${RDEPEND}
	dev-libs/boost
"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-werror
		$(use_with doc docs)
		$(use_enable tools)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
