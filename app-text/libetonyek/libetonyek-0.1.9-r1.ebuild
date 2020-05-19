# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/libreoffice/libetonyek.git"
	inherit autotools git-r3
else
	SRC_URI="https://dev-www.libreoffice.org/src/libetonyek/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
fi
DESCRIPTION="Library parsing Apple Keynote presentations"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"

LICENSE="|| ( GPL-2+ LGPL-2.1 MPL-1.1 )"
SLOT="0"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	app-text/liblangtag
	dev-libs/librevenge
	dev-libs/libxml2
	>=dev-util/mdds-1.4.3:1=
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	media-libs/glm
	sys-devel/libtool
	test? ( dev-util/cppunit )
"

PATCHES=( "${FILESDIR}/${P}-boost-1.73.patch" ) # bug 722042

src_prepare() {
	default
	[[ -d m4 ]] || mkdir "m4"
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-werror
		$(use_with doc docs)
		$(use_enable static-libs static)
		$(use_enable test tests)
	)
	if has_version ">=dev-util/mdds-1.5"; then
		myeconfargs+=( --with-mdds=1.5 )
	else
		myeconfargs+=( --with-mdds=1.4 )
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
