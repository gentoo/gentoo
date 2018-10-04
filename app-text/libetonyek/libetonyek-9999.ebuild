# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://anongit.freedesktop.org/git/libreoffice/libetonyek.git"
[[ ${PV} == 9999 ]] && inherit autotools git-r3

DESCRIPTION="Library parsing Apple Keynote presentations"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
[[ ${PV} == 9999 ]] || SRC_URI="https://dev-www.libreoffice.org/src/libetonyek/${P}.tar.xz"

LICENSE="|| ( GPL-2+ LGPL-2.1 MPL-1.1 )"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="doc static-libs test"

RDEPEND="
	app-text/liblangtag
	dev-libs/librevenge
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	>=dev-util/mdds-1.4.2:1=
	media-libs/glm
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"

src_prepare() {
	default
	[[ -d m4 ]] || mkdir "m4"
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	# mdds installs versioned pkgconfig files
	local p=$(best_version dev-util/mdds)
	local pv=$(echo ${p/%-r[0-9]*/} | rev | cut -d - -f 1 | rev)
	econf \
		--disable-werror \
		--with-mdds=$(ver_cut 1-2 ${pv}) \
		$(use_with doc docs) \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
