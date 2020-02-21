# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/libreoffice/libfreehand.git"
	inherit autotools git-r3
else
	SRC_URI="https://dev-www.libreoffice.org/src/libfreehand/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi
DESCRIPTION="Library for import of FreeHand drawings"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libfreehand"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-libs/librevenge
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-libs/icu
	dev-util/gperf
	media-libs/lcms
	sys-devel/libtool
	test? ( dev-util/cppunit )
"

src_prepare() {
	default
	[[ -d m4 ]] || mkdir "m4"
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	# bug 619762
	append-cxxflags -std=c++14

	local myeconfargs=(
		--disable-werror
		$(use_with doc docs)
		$(use_enable static-libs static)
		$(use_enable test tests)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
